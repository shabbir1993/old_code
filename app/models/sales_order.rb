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

  default_scope { where(tenant_id: Tenant.current_id) }
  scope :by_code, -> { order('substring(code from 6 for 1) DESC, substring(code from 3 for 3) DESC') }
  scope :shipped, -> { where('ship_date is not null') }
  scope :unshipped, -> { where(ship_date: nil) }

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
    films.where(phase: phase).sum { |f| f.order_fill_count }
  end

  def total_assigned_film_percent(phase)
    total_assigned_film_count(phase)*100/total_quantity
  end

  def total_custom_area
    line_items.map{ |li| li.quantity*li.custom_area.to_f }.sum
  end

  def total_assigned_area
    films.map{ |f| f.area.to_f }.sum
  end

  def utilization
    100*total_custom_area/total_assigned_area if total_custom_area && total_assigned_area && total_assigned_area > 0
  end
end
