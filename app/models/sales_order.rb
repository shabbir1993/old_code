class SalesOrder < ActiveRecord::Base
  attr_accessible :code, :customer, :ship_to, :release_date, :due_date, :ship_date, :note, :line_items_attributes

  has_many :line_items, dependent: :destroy
  has_many :films
  belongs_to :tenant
  
  accepts_nested_attributes_for :line_items, allow_destroy: true
  
  validates :code, presence: true, uniqueness: { case_sensitive: false, scope: :tenant_id }

  include PgSearch
  pg_search_scope :search, against: [:code, :customer, :ship_to, :note], 
    :using => { tsearch: { prefix: true } }

  default_scope { where(tenant_id: Tenant.current_id) if Tenant.current_id }
  scope :by_code, -> { order('substring(code from 6 for 1) DESC, substring(code from 3 for 3) DESC') }
  scope :shipped, -> { where('ship_date is not null') }
  scope :unshipped, -> { where(ship_date: nil) }

  def self.ship_date_range(start_date, end_date)
    sales_orders = all
    sales_orders = sales_orders.where("ship_date >= ?", start_date) if start_date
    sales_orders = sales_orders.where("ship_date <= ?", end_date) if end_date
    sales_orders
  end

  def self.with_ship_date(date)
    where("ship_date = ?", date)
  end

  def self.text_search(query)
    if query.present?
      #reorder is workaround for pg_search issue 88
      search(query)
    else
      all
    end
  end

  def total_quantity
    line_items.sum(:quantity)
  end

  def total_assigned_film_count(phase)
    films.where(phase: phase).sum(:order_fill_count)
  end

  def total_assigned_film_percent(phase)
    total_assigned_film_count(phase)*100/total_quantity
  end

  def total_custom_area
    line_items.map{ |li| li.total_area.to_f }.sum
  end

  def total_assigned_area
    films.map{ |f| f.area.to_f }.sum
  end

  def utilization
    100*total_custom_area/total_assigned_area if total_custom_area && total_assigned_area && total_assigned_area > 0
  end

  def self.total_custom_area_by_product_type(type)
    custom_areas = all.map do |s|
      s.line_items.where(product_type: type).map{ |li| li.total_area.to_f }.sum
    end
    custom_areas.sum
  end
end
