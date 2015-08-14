class JobOrder < ActiveRecord::Base
  has_many :job_dates, autosave: true, dependent: :destroy

  validates :serial, presence: true, uniqueness: true

  def set_job_dates(job_dates_attrs)
    job_dates_attrs.each do |job_date_attrs|
      job_date = job_dates.find_or_initialize_by(step: job_date_attrs[:step], date_type: job_date_attrs[:date_type])
      job_date.job_order ||= self
      if job_date_attrs[:value].present?
        job_date.value = job_date_attrs[:value]
        job_date.save!
      else
        job_date.destroy!
      end
    end
  end

  def date_of(step, date_type)
    if job_date = job_dates.find_by(step: step, date_type: date_type)
      job_date.value
    else
      ""
    end
  end
end
