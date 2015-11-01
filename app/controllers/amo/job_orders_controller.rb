class Amo::JobOrdersController < AmoController
  require 'csv'

  http_basic_authenticate_with name: "james", password: "jamesonly"

  def index
    @job_orders = filtered_job_orders.page(params[:page])
  end

  def new
    @job_order = JobOrder.new
    @job_dates = JobDate::STEPS.map do |step|
      @job_order.job_dates.find_or_initialize_by(step: step)
    end
    render layout: false
  end

  def create
    @job_order = JobOrder.new(job_order_params)

    if @job_order.save
      @job_order.set_job_dates(params[:job_order][:job_dates].values)
    else
      render :display_modal_error_messages, locals: { object: @job_order }
    end
  end

  def edit
    session[:return_to] ||= request.referer
    @job_order = JobOrder.find(params[:id])
    @job_dates = JobDate::STEPS.map do |step|
      @job_order.job_dates.find_or_initialize_by(step: step)
    end
    render layout: false
  end

  def update
    @job_order = JobOrder.find(params[:id])
    @job_order.attributes = job_order_params

    if @job_order.save
      @job_order.set_job_dates(params[:job_order][:job_dates].values)
    else
      render :display_modal_error_messages, locals: { object: @job_order }
    end
  end

  def destroy
    @job_order = JobOrder.find(params[:id])
    @job_order.destroy!
    redirect_to session.delete(:return_to), notice: "Job Order #{@job_order.serial} deleted."
  end

  def new_import
  end

  def import
    csv_file = params[:job_orders_csv]

    if csv_file.nil? || File.extname(csv_file.original_filename) != ".csv"
      flash[:alert] = "Please choose a csv file."
    else
      JobOrder.destroy_all
      CSV.foreach(csv_file.path, headers: true) do |row|
        job_order_number = row["job_order_number"]
        if job_order_number.present?
          job_order = JobOrder.find_or_initialize_by(serial: job_order_number)
          job_order.part_number = row["part_number"] || ""
          job_order.run_number = row["run_number"] || ""
          job_order.quantity = row["quantity"] || ""
          job_order.priority = row["priority"] || ""

          job_order.save!

          JobDate::STEPS.each do |step|
            date_string = row[step]
            if date_string.present?
              job_date = job_order.job_dates.find_or_initialize_by(step: step)
              if completed_date_match = /\[(.*?)\]/.match(date_string)
                date_string = completed_date_match[0]
                job_date.completed = true
              end
              parsed_date = Date.strptime(date_string.strip, '%m/%d/%Y')
              job_date.value = parsed_date
              job_date.save!
            end
          end
        end
      end
      flash[:notice] = "Job orders imported"
    end

    redirect_to new_import_job_orders_path
  end

  private

  def job_order_params
    params.require(:job_order).permit(:serial, :part_number, :run_number, :quantity, :priority, :note)
  end

  def filtered_job_orders
    @filtered_job_orders ||= JobOrder
    .filter(filtering_params)
    .by_serial
  end
  helper_method :filtered_job_orders

  def filtering_params
    params.slice(:text_search, :serial_like, :run_number_like, :part_number_like)
  end
end
