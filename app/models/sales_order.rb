class SalesOrder < ActiveRecord::Base
  attr_accessible :code, :customer, :ship_to, :release_date, :due_date, :ship_date, :note, :line_items_attributes

  has_many :line_items, dependent: :destroy
  has_many :films
  
  accepts_nested_attributes_for :line_items, allow_destroy: true
  
  validates :code, presence: true, uniqueness: { case_sensitive: false },
    format: { with: /\A[A-Z]{2}\d{3}[A-Z]\z/ }

  include PgSearch
  pg_search_scope :search, against: [:code, :customer, :ship_to, :note], 
    :using => { tsearch: { prefix: true } }

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
end
