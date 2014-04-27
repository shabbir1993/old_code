class LineItem < ActiveRecord::Base
  attr_accessible :custom_width, :custom_length, :quantity, :product_type, :wire_length, :busbar_type, :note

  belongs_to :sales_order

  delegate :code, to: :sales_order, prefix: true, allow_nil: true
  
  validates :custom_width, presence: true
  validates :custom_length, presence: true
  validates :product_type, presence: true
  validates :quantity, numericality: { greater_than: 0 }

  scope :product_type_equals, ->(type) { where(product_type: type) }

  def custom_area
    custom_width*custom_length / sales_order.tenant.area_divisor
  end

  def total_area
    custom_area*quantity
  end

  def self.total_area
    all.map { |li| li.total_area }.sum
  end
end
