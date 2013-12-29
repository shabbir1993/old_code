class Film < ActiveRecord::Base

  attr_accessible :width, :length, :note, :shelf, :phase, :destination, :deleted, :sales_order_id, :order_fill_count, :master_film_id
  attr_reader :destination

  belongs_to :master_film
  belongs_to :sales_order
  belongs_to :tenant

  delegate :formula, :effective_width, :effective_length, :effective_area, to: :master_film
  delegate :code, to: :sales_order, prefix: true, allow_nil: true

  before_create :set_division
  before_save :upcase_shelf

  validates :phase, presence: true
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
  scope :by_serial, -> { joins(:master_film).order('master_films.serial DESC, division ASC') }
  scope :small, -> { where("width*length/#{Tenant.find(Tenant.current_id).area_divisor} < ?", Tenant.find(Tenant.current_id).small_area_cutoff) }
  scope :large, -> { where("width*length/#{Tenant.find(Tenant.current_id).area_divisor} >= ? or width IS NULL or length IS NULL", Tenant.find(Tenant.current_id).small_area_cutoff) }
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
  scope :deleted, -> { where(deleted: true).by_serial }
  scope :active, -> { where(deleted: false) }
  scope :by_area, -> { order('width*length ASC') }
  scope :usable, -> { active.where("phase <> 'scrap' AND phase <> 'nc'") }

  def destination=(destination)
    if destination.present?
      self.phase = destination
      self.sales_order_id = nil unless %w(stock wip fg).include?(destination)
    end
  end
  
  def serial
    master_film.serial + "-" + division.to_s
  end

  def area
    (width * length / tenant.area_divisor) if width && length
  end

  def upcase_shelf
    shelf.upcase! if shelf.present?
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

  def self.total_area
    select("width, length, films.tenant_id").map{ |f| f.area.to_f }.sum
  end

  def set_division
    self.division ||= (master_film.films.pluck(:division).max.to_i) + 1
  end

  def self.search_dimensions(min_width, max_width, min_length, max_length)
    if min_width.present? || max_width.present? || min_length.present? || max_length.present?
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
      reorder('').search(query).order('id DESC')
    else
      all
    end
  end

  def area_change
    area_was = nil
    area_is = nil
    if width_was && length_was
      area_was = width_was*length_was/tenant.area_divisor
    end
    if width && length
      area_is = width*length/tenant.area_divisor
    end
    [area_was, area_is]
  end

  def self.to_csv(options = {})
    CSV.generate(options) do |csv|
      csv << %w(Serial Formula Width Length Area Shelf SO Phase)
      all.each do |f|
        csv << [f.serial, f.formula, f.width, f.length, f.area, f.shelf, f.sales_order_code, f.phase]
      end
    end
  end
end
