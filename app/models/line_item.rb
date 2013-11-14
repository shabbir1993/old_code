class LineItem < ActiveRecord::Base
  attr_accessible :custom_width, :custom_length, :quantity, :product_type, :wire_length, :busbar_type, :note

  belongs_to :sales_order

  delegate :code, to: :sales_order, prefix: true, allow_nil: true
  
  validates :custom_width, presence: true
  validates :custom_length, presence: true
  validates :quantity, numericality: { greater_than: 0 }
end
