class SalesOrder < ActiveRecord::Base
  attr_accessible :code, :customer, :ship_to, :release_date, :due_date, :line_items_attributes

  has_many :line_items, dependent: :destroy
  
  accepts_nested_attributes_for :line_items, allow_destroy: true
  
  validates :code, presence: true, uniqueness: { case_sensitive: false },
    format: { with: /\A[A-Z]{2}\d{3}[A-Z]\z/, on: :create }
  validates :customer, presence: true

  scope :by_code, -> { order('substring(code from length (code)) DESC, substring(code from 3 for 3) DESC') }

  def total_quantity
    line_items.sum(:quantity)
  end

  def total_assigned_film_count(phase)
    line_items.sum { |l| l.assigned_film_count(phase) }
  end

  def total_assigned_film_percent(phase)
    line_items.sum {|l| l.assigned_film_count(phase) }*100/total_quantity
  end
end
