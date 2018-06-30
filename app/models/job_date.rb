class JobDate < ApplicationRecord
  include Filterable

  STEPS = %w(released YR WR fill ET PLZ mask BE QC).freeze
  FE_DISPLAY_STEPS = %w(YR WR fill ET SM).freeze
  BE_DISPLAY_STEPS = %w(mask PLZ BE QC FG).freeze

  extend SimpleCalendar
  has_calendar attribute: :value

  belongs_to :job_order

  delegate :part_number, :quantity, :serial, :run_number, :rush?, :urgent?, to: :job_order

  validates :job_order, presence: true
  validates :step, inclusion: { in: STEPS }
  validates :value, presence: true
  validates_uniqueness_of :job_order_id, scope: :step

  scope :join_job_orders, -> { joins('INNER JOIN job_orders ON job_orders.id = job_dates.job_order_id') }

  scope :text_search, ->(query) { reorder('').search(query) }
  scope :part_number_like, ->(part_number) { join_job_orders
                                        .merge(JobOrder.part_number_like(part_number)) }

  include PgSearch
  pg_search_scope :search, 
    against: [:step], 
    using: { tsearch: { prefix: true } },
    associated_against: { job_order: [:serial, :part_number, :quantity, :run_number, :note] }

  def display_step
    if step == "due" && job_order.supermarket?
      "SM"
    elsif step == "due"
      "FG"
    else
      step
    end
  end
end
