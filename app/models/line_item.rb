class LineItem < ActiveRecord::Base

  belongs_to :sales_order

  delegate :code, to: :sales_order, prefix: true
  
  validates :custom_width, presence: true, numericality: { greater_than_or_equal_to: 0 }
  validates :custom_length, presence: true, numericality: { greater_than_or_equal_to: :custom_width }
  validates :product_type, presence: true
  validates :quantity, numericality: { greater_than: 0 }

  scope :product_type_equals, ->(type) { where(product_type: type) }

  def self.total_quantity
    all.sum(:quantity)
  end

  def custom_area
    custom_width*custom_length/tenant.area_divisor
  end

  def total_area
    custom_area*quantity
  end

  def self.total_area
    all.map { |li| li.total_area }.sum
  end

  def self.to_csv(options = {})
    CSV.generate(options) do |csv|
      csv << %w(SO# Type Custom-W Custom-L Pieces Wires Busbars Note)
      all.each do |o|
        csv << [o.sales_order_code, o.product_type, o.custom_width, o.custom_length, o.quantity, o.wire_length, o.busbar_type, o.note]
      end
    end
  end

  def tenant
    @tenant ||= sales_order.tenant
  end
end
