class JobOrder < ActiveRecord::Base
  include Filterable

  has_many :job_dates, autosave: true, dependent: :destroy

  validates :serial, presence: true, uniqueness: true

  scope :serial_like, ->(serial) { where('serial ILIKE ?', serial.gsub('*', '%')) }
  scope :part_number_like, ->(part_number) { where('part_number ILIKE ?', part_number.gsub('*', '%')) }
  scope :run_number_like, ->(run_number) { where('run_number ILIKE ?', run_number.gsub('*', '%')) }
  scope :by_serial, -> { order('job_orders.serial DESC') }
  scope :text_search, ->(query) { reorder('').search(query) }

  include PgSearch
  pg_search_scope :search, 
    against: [:serial, :part_number, :quantity, :run_number, :note], 
    using: { tsearch: { prefix: true } }

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

  def supermarket?
    part_number =~ /^sm/i
  end

  def rush?
    !!(priority =~ /rush/i)
  end

  def urgent?
    !!(priority =~ /urgent/i)
  end
end
