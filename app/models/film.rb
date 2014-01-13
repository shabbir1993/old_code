class Film < ActiveRecord::Base
  include Exportable
  include Importable

  SECOND_WIDTH_SQL = "substring(films.note from '([0-9]+([.][0-9]+)?)[ ]*[xX][ ]*([0-9]+([.][0-9]+)?)')::decimal"
  SECOND_LENGTH_SQL = "substring(films.note from '(?:[0-9]+(?:[.][0-9]+)?)[ ]*[xX][ ]*([0-9]+([.][0-9]+)?)')::decimal"

  attr_accessible :width, :length, :note, :shelf, :phase, :destination, :deleted, :sales_order_id, :order_fill_count, :master_film_id
  attr_reader :destination

  belongs_to :master_film
  belongs_to :sales_order
  belongs_to :tenant

  delegate :formula, to: :master_film
  delegate :code, to: :sales_order, prefix: true, allow_nil: true

  before_create :set_division
  before_save :upcase_shelf

  validates :phase, presence: true
  validates :width, :length, presence: true, unless: lambda { |film| PhaseDefinitions.front_end?(film.phase) }
  validates :order_fill_count, numericality: { greater_than: 0 }

  has_paper_trail :only => [:phase, :shelf, :width, :length, :deleted],
                  :meta => { columns_changed: Proc.new { |film| film.changed },
                             phase_change: Proc.new { |film| film.changes[:phase] || [film.phase, film.phase] },
                             area_change: Proc.new { |film| film.area_change } }

  include PgSearch
  pg_search_scope :search, against: [:division, :note, :shelf, :phase], 
    :using => { tsearch: { prefix: true } },
    associated_against: {
      master_film: [:serial, :formula],
      sales_order: [:code]
    }

  default_scope { where(tenant_id: Tenant.current_id) }
  scope :phase, ->(phase) { active.where(phase: phase) }
  scope :small, -> { where("width*length/#{Tenant.current_area_divisor} < ?", Tenant.current_small_area_cutoff) }
  scope :large, -> { where("width*length/#{Tenant.current_area_divisor} >= ? or width IS NULL or length IS NULL", Tenant.current_small_area_cutoff) }
  scope :reserved, -> { where("sales_order_id IS NOT NULL") }
  scope :not_reserved, -> { where("sales_order_id IS NULL") }
  scope :active, -> { where(deleted: false) }
  scope :usable, -> { active.where("phase <> 'scrap' AND phase <> 'nc'") }
  scope :min_width, ->(width = 0) { where("width >= ?", width) }
  scope :min_length, ->(length = 0) { where("length >= ?", length) }

  #tabs
  scope :select_fields, -> { joins("LEFT OUTER JOIN master_films ON master_films.id = films.master_film_id")
    .joins("LEFT OUTER JOIN sales_orders ON sales_orders.id = films.sales_order_id")
    .select("films.*, 
             master_films.serial || '-' || films.division as serial, 
             width*length/#{Tenant.current_area_divisor} as area, 
             sales_orders.code as sales_order_code, 
             #{SECOND_WIDTH_SQL} as second_width, 
             #{SECOND_LENGTH_SQL} as second_length,
             #{SECOND_WIDTH_SQL}*#{SECOND_LENGTH_SQL}/#{Tenant.current_area_divisor} as second_area") }
  scope :lamination, -> { select_fields.phase("lamination") }
  scope :inspection, -> { select_fields.phase("inspection") }
  scope :large_stock, -> { select_fields.phase("stock").large.not_reserved }
  scope :small_stock, -> { select_fields.phase("stock").small.not_reserved }
  scope :reserved_stock, -> { select_fields.phase("stock").reserved }
  scope :wip, -> { select_fields.phase("wip") }
  scope :fg, -> { select_fields.phase("fg") }
  scope :test, -> { select_fields.phase("test") }
  scope :nc, -> { select_fields.phase("nc") }
  scope :scrap, -> { select_fields.phase("scrap") }
  scope :deleted, -> { select_fields.where(deleted: true) }
  
  def serial
    master_film.serial + "-" + division.to_s
  end
  
  def area
    AreaCalculator.calculate(width, length, tenant.area_divisor)
  end

  def destination=(destination)
    if destination.present?
      write_attribute(:phase, destination)
      write_attribute(:sales_order_id, nil) unless %w(stock wip fg).include?(destination)
    end
  end

  def width=(width)
    master_film.update_attributes(effective_width: width) if PhaseDefinitions.front_end?(phase)
    write_attribute(:width, width)
  end

  def length=(length)
    master_film.update_attributes(effective_length: length) if PhaseDefinitions.front_end?(phase)
    write_attribute(:length, length)
  end

  def upcase_shelf
    shelf.upcase! if shelf.present?
  end

  def self.total_area
    all.map{ |f| f.area.to_f }.sum
  end

  def set_division
    self.division ||= (master_film.films.pluck(:division).max.to_i) + 1
  end

  def projected_utilization(film_width, film_length, custom_width, custom_length)
    if custom_width && custom_length && film_width && film_length && custom_width <= film_width && custom_length <= film_length
      100*(custom_width*custom_length/tenant.area_divisor)/(film_width*film_length/tenant.area_divisor)
    end
  end

  def self.search_text(query)
    if query.present?
      #reorder is workaround for pg_search issue 88
      reorder('').search(query)
    else
      all
    end
  end

  def self.search_dimensions(min_width, min_length)
    results = all
    if min_width && min_length
      results = results.where("width >= :min_width AND length >= :min_length OR #{SECOND_WIDTH_SQL} >= :min_width AND #{SECOND_LENGTH_SQL} >= :min_length", { min_width: min_width, min_length: min_length } )
    else
      results = results.where("width >= :min_width OR #{SECOND_WIDTH_SQL} >= :min_width", min_width: min_width) if min_width.present?
      results = results.where("length >= :min_length OR #{SECOND_LENGTH_SQL} >= :min_length", min_length: min_length) if min_length.present?
    end
    results
  end

  def area_change
    area_was = nil
    area_is = nil
    if width_was && length_was
      area_was = width_was*length_was/Tenant.current_area_divisor
    end
    if width && length
      area_is = width*length/Tenant.current_area_divisor
    end
    [area_was, area_is]
  end

  def self.data_for_export
    data = [] << %w(Serial Formula Width Length Area Shelf SO Phase)
    all.limit(5000).each do |f|
      data << [f.serial, f.formula, f.width, f.length, f.area, f.shelf, f.sales_order_code, f.phase]
    end
    data
  end
end
