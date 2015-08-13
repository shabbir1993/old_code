class Amo::JobOrdersController < AmoController
  require 'csv'

  http_basic_authenticate_with name: "james", password: "jamesonly"

  def index
    @job_orders = JobOrder.order(serial: :desc).page(params[:page])
  end

  def new
    @job_order = JobOrder.new
    @job_dates = JobDate::STEPS.map do |step|
      @job_order.job_dates.find_or_initialize_by(step: step, date_type: "planned")
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
      @job_order.job_dates.find_or_initialize_by(step: step, date_type: "planned")
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

  def import_csv
    csv_file = params[:job_orders_csv]
    CSV.foreach(csv_file.path, headers: true) do |row|
      job_order_number = row["Job Order No."]
      if job_order_number
        job_order = JobOrder.find_or_initialize_by(serial: row["Job Order No."])

        job_order.part_number = row["Part Number"] || ""
        job_order.run_number = row["Run Number"] || ""
        job_order.quantity = row["Qty."] || ""

        job_order.save!

        [
          ["Date Released", "released"],
          ["Due date", "due"],
          ["Y.R.", "YR"],
          ["W.R.", "WR"],
          ["Fill", "fill"],
          ["E. Test", "Etest"],
          ["PLZ", "PLZ"],
          ["Mask", "mask"],
          ["BE", "BE"],
          ["Q.C.", "QC"]
        ].each do |date_pair|
          date_string = row[date_pair[0]]
          logger.debug(date_string)
          if date_string.present?
            logger.debug("HELLO")
            job_date = job_order.job_dates.find_or_initialize_by(step: date_pair[1])

            job_date.date_type = params[:date_type]
            parsed_date = date_string.to_date
            if parsed_date.year < 2000
              parsed_date.change(year: parsed_date.year + 2000)
            end
            job_date.value = parsed_date
            job_date.save!
          end
        end
      end
    end

    redirect_to job_orders_path, notice: "Job orders imported."
  end

  private

  def job_order_params
    params.require(:job_order).permit(:serial, :part_number, :run_number, :quantity, :note)
  end
end
