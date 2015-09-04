class Amo::JobDatesController < AmoController
  http_basic_authenticate_with name: "avionics", password: "PI805"

  def index
    @job_dates = month_job_dates
  end

  private

  def month_job_dates
    selected_date = params.fetch(:start_date, Time.zone.today).to_date
    @month_job_dates ||= JobDate.where(value: selected_date.beginning_of_month.beginning_of_week..selected_date.end_of_month.end_of_week)
  end

  def found_job_dates
    if any_searches?
      @found_job_dates ||= month_job_dates.filter(filtering_params)
    else
      @found_job_dates ||= []
    end
  end
  helper_method :found_job_dates

  def filtering_params
    params.slice(:text_search)
  end
end
