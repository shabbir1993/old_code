class Avionics::JobDatesController < AvionicsController
  http_basic_authenticate_with name: "avionics", password: "PI805"

  def index
    start_date = params.fetch(:start_date, Time.zone.today.beginning_of_month).to_date
    @job_dates = AvionicsJobDate.where(value: start_date..start_date.end_of_month)
  end
end

