class SalesOrder < ApplicationRecord
  include Filterable
  include Tenancy

  enum status: [ :in_progress, :on_hold, :cancelled, :shipped ]

  has_many :line_items, dependent: :destroy
  has_many :films
  
  accepts_nested_attributes_for :line_items, allow_destroy: true
  
  validates :code, presence: true, 
                   uniqueness: { case_sensitive: false, 
                                 scope: :tenant_code }
  validates :ship_date, presence: true, if: Proc.new { |o| o.shipped? }
  validate :ship_date_after_release?
  validates :release_date, presence: true
  validates :due_date, presence: true

  include PgSearch
  pg_search_scope :search, against: [:code, :customer, :ship_to, :note], 
    :using => { tsearch: { prefix: true } }

  scope :order_by, ->(col, dir) { order("#{col} #{dir}") }
  scope :status, ->(status) { where(status: statuses[status]) }
  scope :due_date_equals, ->(date) { where(due_date: date) }
  scope :type, ->(prefix) { where('code ILIKE ?', prefix) }
  scope :ship_date_before, ->(date) { where("ship_date <= ?", date) } 
  scope :ship_date_after, ->(date) { where("ship_date >= ?", date) } 
  scope :text_search, ->(query) { reorder('').search(query) }
  scope :code_like, ->(code) { where('code ILIKE ?', code.gsub('*', '%')) }
  scope :status_not, ->(status) { where("status <> ?", statuses[status]) }

  def lead_days
    (ship_date - release_date).to_i
  end

  def total_quantity
    line_items.total_quantity
  end

  def assigned_film_count(phase = nil)
    assigned = phase ? films.phase(phase) : films
    assigned.total_order_fill_count
  end

  def assigned_film_percentage
    return 0 if total_quantity == 0
    100*assigned_film_count/total_quantity
  end

  def total_custom_area
    line_items.total_area
  end

  def total_assigned_area
    films.map{ |f| f.area }.sum
  end

  def past_due?
    Date.current > due_date
  end

  def shipped_late?
    ship_date ? ship_date > due_date : false
  end

  def utilization
    100*total_custom_area/total_assigned_area if total_custom_area && total_assigned_area && total_assigned_area > 0
  end

  def self.avg_utilization
    100*total_custom_area/total_assigned_area if total_custom_area && total_assigned_area && total_assigned_area > 0
  end

  def self.total_custom_area
    line_items.total_area
  end

  def self.total_assigned_area
    films.map{ |f| f.area }.sum
  end

  def self.line_items
    LineItem.where(sales_order_id: all.map(&:id))
  end

  def self.films
    Film.where(sales_order_id: all.map(&:id))
  end

  def self.to_csv(options = {})
    CSV.generate(options) do |csv|
      csv << %w(SO# Customer Released Due Ship-to Status Shipped Note)
      all.each do |o|
        csv << [o.code, o.customer, o.release_date, o.due_date, o.ship_to, o.status, o.ship_date, o.note]
      end
    end
  end

  private

  def ship_date_after_release?
    if ship_date.present? && ship_date < release_date
      errors.add(:base, "Must be shipped after release")
    end
  end
end
