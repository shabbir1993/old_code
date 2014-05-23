class SalesOrder < ActiveRecord::Base
  include ActionView::Helpers::NumberHelper
  include PgSearch
  include Filterable
  include Tenancy

  cattr_accessor :group_start_date, :display_date

  attr_accessible :code, :customer, :ship_to, :release_date, :due_date, :ship_date, :note, :line_items_attributes, :cancelled

  enum status: [ :in_progress, :on_hold, :cancelled, :shipped ]

  has_many :line_items, dependent: :destroy
  has_many :films
  
  accepts_nested_attributes_for :line_items, allow_destroy: true
  
  validates :code, presence: true, 
                   uniqueness: { case_sensitive: false, 
                                 scope: :tenant_code }
  validates :ship_date, presence: true, if: Proc.new { |o| o.shipped? }
  validates :release_date, presence: true
  validates :due_date, presence: true

  pg_search_scope :search, against: [:code, :customer, :ship_to, :note], 
    :using => { tsearch: { prefix: true } }

  scope :by_code, -> { order('substring(code from 6 for 1) DESC, substring(code from 3 for 3) DESC') }
  scope :has_release_date, -> { where('release_date is not null') }
  scope :has_due_date, -> { where('due_date is not null') }
  scope :type, ->(prefix) { where('code ILIKE ?', prefix) }
  scope :ship_date_before, ->(date) { where("ship_date <= ?", Time.zone.parse(date)) } 
  scope :ship_date_after, ->(date) { where("ship_date >= ?", Time.zone.parse(date)) } 
  scope :text_search, ->(query) { reorder('').search(query) }

  def lead_days
    (ship_date - release_date).to_i
  end

  def total_quantity
    line_items.total_quantity
  end

  def assigned_film_count
    films.sum(:order_fill_count)
  end

  def assigned_film_percentage
    100*assigned_film_count/total_quantity
  end

  def total_custom_area
    line_items.total_area
  end

  def total_assigned_area
    films.map{ |f| f.area.to_f }.sum
  end

  def utilization
    100*total_custom_area/total_assigned_area if total_custom_area && total_assigned_area && total_assigned_area > 0
  end

  def self.line_items
    LineItem.where(sales_order_id: all.map(&:id))
  end

  def self.to_csv(options = {})
    CSV.generate(options) do |csv|
      csv << %w(SO# Customer Released Due Ship-to Status Shipped Note)
      all.each do |o|
        csv << [o.code, o.customer, o.release_date, o.due_date, o.ship_to, o.status, o.ship_date, o.note]
      end
    end
  end
end
