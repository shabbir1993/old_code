class Avionics::JobOrdersController < AvionicsController
  require 'csv'

  http_basic_authenticate_with name: "james", password: "jamesonly"

  def index
  end

  def import_csv
    csv_file = params[:job_orders_csv]
    CSV.foreach(csv_file.path, headers: true) do |row|
      job_order_number = row["Job Order No."]
      if job_order_number
        job_order = AvionicsJobOrder.find_or_initialize_by(serial: row["Job Order No."])

        job_order.part_number = row["Part Number"] || ""
        job_order.run_number = row["Run Number"] || ""
        job_order.quantity = row["Quantity"] || ""

        [
          ["Date Released", "released"],
          ["Due date", "due"],
          ["Y.R.", "YR"],
          ["W.R.", "WR"],
          ["Fill", "fill"],
          ["E. Test", "ETest"],
          ["PLZ", "PLZ"],
          ["Mask", "mask"],
          ["BE", "BE"],
          ["Q.C.", "QC"]
        ].each do |date_pair|
          if row[date_pair[0]].present?
            job_date = job_order.avionics_job_dates.find_or_initialize_by(step: date_pair[1])

            job_date.date_type = params[:date_type]
            job_date.value = row[date_pair[0]].to_date
          end
        end

        job_order.save!

      end
    end

    redirect_to avionics_job_orders_path, notice: "Job orders imported."
  end
end
