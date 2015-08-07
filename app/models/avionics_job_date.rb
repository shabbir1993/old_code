class AvionicsJobDate < ActiveRecord::Base
  extend SimpleCalendar
  has_calendar attribute: :value

  belongs_to :avionics_job_order

  validates :avionics_job_order, presence: true
  validates :step, inclusion: { in: %w(released due YR WR fill ETest PLZ mask BE QC) }
  validates :date_type, inclusion: { in: %w(planned actual) }
  validates :value, presence: true
end
