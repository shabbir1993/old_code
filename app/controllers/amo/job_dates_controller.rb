class Amo::JobDatesController < AmoController
  http_basic_authenticate_with name: "avionics", password: "PI805"

  def index
    start_date = params.fetch(:start_date, Time.zone.today).to_date
    @job_dates = JobDate.where(value: start_date.beginning_of_month.beginning_of_week..start_date.end_of_month.end_of_week)
  end
end

