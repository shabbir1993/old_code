class Film < ActiveRecord::Base

  attr_accessible :width, :length, :note, :shelf, :effective_width, :effective_length, :phase, :destination, :deleted, :sales_order_id, :order_fill_count, :master_film_attributes
  attr_reader :destination

  belongs_to :master_film
  belongs_to :sales_order
  has_many :film_movements

  accepts_nested_attributes_for :master_film

  delegate :formula, :effective_width, :effective_length, :effective_area, to: :master_film
  delegate :code, to: :sales_order, prefix: true, allow_nil: true

  before_create :set_division

  validates :phase, presence: true
  validates :order_fill_count, numericality: { greater_than: 0 }

  has_paper_trail :only => [:phase, :shelf, :width, :length, :deleted],
                  :meta => { columns_changed: Proc.new { |film| film.changed },
                             phase_change: Proc.new { |film| film.changes[:phase] || [film.phase, film.phase] },
                             area_change: Proc.new { |film| film.area_change },
                             area: Proc.new { |film| film.area } }


  include PgSearch
  pg_search_scope :search, against: [:division, :note, :shelf, :phase], 
    :using => { tsearch: { prefix: true } },
    associated_against: {
      master_film: [:serial, :formula],
      sales_order: [:code]
    }

  default_scope { where(deleted: false) }
  scope :phase, ->(phase) { where(phase: phase) }
  scope :by_serial, -> { joins(:master_film).order('master_films.serial DESC, division ASC') }
  scope :small, -> { where('width*length/144 < ?', 16) }
  scope :large, -> { where('width*length/144 >= ? or width IS NULL or length IS NULL', 16) }
  scope :reserved, -> { where("sales_order_id IS NOT NULL") }
  scope :not_reserved, -> { where("sales_order_id IS NULL") }
  scope :lamination, -> { phase("lamination").by_serial }
  scope :inspection, -> { phase("inspection").by_serial }
  scope :large_stock, -> { phase("stock").large.not_reserved.by_serial }
  scope :small_stock, -> { phase("stock").small.not_reserved.by_serial }
  scope :reserved_stock, -> { phase("stock").reserved.by_serial }
  scope :wip, -> { phase("wip").by_serial }
  scope :fg, -> { phase("fg").by_serial }
  scope :test, -> { phase("test").by_serial }
  scope :nc, -> { phase("nc").by_serial }
  scope :scrap, -> { phase("scrap").by_serial }
  scope :deleted, -> { unscoped.where(deleted: true).by_serial }
  scope :by_area, -> { order('width*length ASC') }

  def destination=(destination)
    if destination.present?
      self.phase = destination
      self.sales_order_id = nil unless %w(stock wip fg).include?(destination)
    end
  end
  
  def effective_width=(effective_width)
    self.width = effective_width
    master_film.effective_width = effective_width
  end

  def effective_length=(effective_length)
    self.length = effective_length
    master_film.effective_length = effective_length
  end

  def serial
    master_film.serial + "-" + division.to_s
  end

  def area
    (width * length / 144).round(2) if width && length
  end

  def order_with_count
    if order_fill_count == 1
      sales_order_code
    else
      sales_order_code + " x " + order_fill_count.to_s
    end
  end

  def valid_destinations
    case phase
    when "lamination"
      ["inspection"]
    when "inspection"
      %w{stock wip test nc}
    when "stock"
      %w{wip test nc}
    when "wip"
      %w{fg stock test nc}
    when "fg"
      %w{wip stock test nc}
    when "test"
      %w{stock nc}
    when "nc"
      %w{scrap stock test}
    when "scrap"
      %w{stock nc test}
    else
      []
    end
  end

  def sibling_films
    Film.where(master_film_id: master_film_id)
  end

  def sibling_count
    sibling_films.count
  end

  def set_division
    self.division ||= sibling_films.count + 1
  end

  def self.search_dimensions(min_width, max_width, min_length, max_length)
    if min_width || max_width || min_length || max_length
      films = all
      films = films.where("width >= ?", min_width) if min_width.present?
      films = films.where("width <= ?", max_width) if max_width.present?
      films = films.where("length >= ?", min_length) if min_length.present?
      films = films.where("length <= ?", max_length) if max_length.present?
      films.by_area
    else
      all
    end
  end

  def self.text_search(query)
    if query.present?
      #reorder is workaround for pg_search issue 88
      reorder('').search(query)
    else
      all
    end
  end

  def area_change
    area_was = nil
    area_is = nil
    if width_was && length_was
      area_was = width_was*length_was/144
    end
    if width && length
      area_is = width*length/144
    end
    [area_was, area_is]
  end
end
