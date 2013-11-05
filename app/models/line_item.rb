class LineItem < ActiveRecord::Base
  attr_accessible :custom_width, :custom_length, :quantity, :wire_length, :busbar_type, :note

  belongs_to :sales_order
  has_many :films

  delegate :code, to: :sales_order, prefix: true, allow_nil: true
  
  validates :custom_width, presence: true
  validates :custom_length, presence: true
  validates :quantity, numericality: { greater_than: 0 }

  def self.unfilled
    LineItem.all.select do |i| 
       i.films.count < i.quantity
    end
  end

  def select_text
    "#{custom_width} x #{custom_length} - #{sales_order.code} - #{sales_order.customer}"
  end

  def assigned_film_count(phase)
    films.where(phase: phase).count
  end

  def assigned_film_percent(phase)
    assigned_film_count(phase)*100/quantity
  end
end
