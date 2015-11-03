class Amo::JobDatesController < AmoController
  http_basic_authenticate_with name: "avionics", password: "PI805"

  def index
    @month_grouped_job_dates = JobDate.order(:value).group_by { |jd| jd.value.beginning_of_month }
  end

  def be_schedule
    today = Time.zone.today
    four_week_be_dates = JobDate.where(value: today.beginning_of_week..(today + 28).end_of_week, step: "BE").order(value: :asc)
    @week_grouped_be_dates = four_week_be_dates.group_by do |job_date|
      job_date.value.beginning_of_week
    end

    render layout: 'application'
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
    params.slice(:text_search, :part_number_like)
  end
end
