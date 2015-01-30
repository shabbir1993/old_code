class Film < ActiveRecord::Base
  require 'rqrcode'
  include Filterable
  include Tenancy

  belongs_to :master_film
  belongs_to :sales_order
  has_many :film_movements
  has_many :dimensions, -> { order('id ASC') }

  accepts_nested_attributes_for :dimensions, allow_destroy: true, reject_if: proc { |attributes| attributes['width'].blank? || attributes['length'].blank? }

  enum phase: [ :lamination, :inspection, :stock, :reserved, :wip, :fg, :nc, :scrap]

  delegate :formula, :serial_date, :b_value, to: :master_film
  delegate :code, to: :sales_order, prefix: true, allow_nil: true
  delegate :width, :length, to: :primary_dimension

  before_update :set_area
  before_save :upcase_shelf

  validates :phase, presence: true
  validates :order_fill_count, numericality: { greater_than: 0 }
  validate :must_have_dimensions, on: :update

  scope :join_dimensions, -> { joins('LEFT OUTER JOIN dimensions ON dimensions.film_id = films.id').uniq }
  scope :join_master_films, -> { joins('INNER JOIN master_films ON master_films.id = films.master_film_id') }
  scope :active, -> { where(deleted: false)
                     .join_master_films
                     .merge(MasterFilm.function_not(:test)) }
  scope :deleted, -> { where(deleted: true) }
  scope :not_deleted, -> { where(deleted: false) }
  scope :has_shelf, -> { where("shelf <> ''") }
  scope :large, ->(cutoff) { join_dimensions.merge(Dimension.large(cutoff)) }
  scope :small, ->(cutoff) { join_dimensions.merge(Dimension.small(cutoff)) }
  scope :text_search, ->(query) { reorder('').search(query) }
  scope :formula_like, ->(formula) { join_master_films
                                    .merge(MasterFilm.formula_like(formula)) }
  scope :order_by, ->(col, dir) { order("#{col} #{dir}") }
  scope :width_greater_than, ->(n) { join_dimensions.merge(Dimension.min_width(n)) }
  scope :length_greater_than, ->(n) { join_dimensions.merge(Dimension.min_length(n)) }
  scope :serial_date_before, ->(date) { join_master_films.merge(MasterFilm.serial_date_before(date)) }
  scope :serial_date_after, ->(date) { join_master_films.merge(MasterFilm.serial_date_after(date)) }

  include PgSearch
  pg_search_scope :search, 
    against: [:serial, :note, :shelf, :phase], 
    using: { tsearch: { prefix: true } },
    associated_against: { master_film: [:formula], sales_order: [:code] }

  def split
    master_film.create_film(phase, width, length)
  end

  def create_dimension(width = 0, length = 0)
    dimensions.create!(width: width, length: length)
  end

  def update_and_move(attrs, destination, actor)
    before_phase = phase
    if update(attrs)
      if %(lamination inspection).include?(before_phase)
        master_film.effective_width = width
        master_film.effective_length = length
        master_film.save!
      end
      if destination.present? && destination != self.phase
        move_to(destination, actor)
      end
      true
    end
  end

  def self.phase(phase, tenant = nil)
    case phase
    when "lamination", "inspection", "stock", "reserved", "wip", "fg", "nc", "scrap"
      active.send(phase)
    when "large_stock"
      active.stock.large(tenant.small_area_cutoff)
    when "small_stock"
      active.stock.small(tenant.small_area_cutoff)
    when "deleted"
      deleted
    end
  end

  def self.total_order_fill_count
    all.sum(:order_fill_count)
  end

  def move_to(destination, actor)
    reset_sales_order unless %w(stock reserved wip fg).include?(destination)
    self.phase = destination
    record_movement(phase_was, destination, actor)
    save!
  end

  def record_movement(from, to, actor)
    film_movements.create!(from_phase: from, 
                           to_phase: to, 
                           actor: actor.full_name, 
                           width: width,
                           length: length,
                           tenant_code: tenant_code)
  end

  def self.total_area
    all.map{ |f| f.area }.sum.to_f
  end

  def self.to_csv(options = {})
    CSV.generate(options) do |csv|
      csv << %w(Serial Formula Width Length Area Shelf SO Phase)
      all.join_dimensions.each do |f|
        csv << [f.serial, f.formula, f.width, f.length, f.area, f.shelf, f.sales_order_code, f.phase]
      end
    end
  end

  def valid_destinations
    case phase
    when "lamination"
      %w{inspection}
    when "inspection"
      %w{stock reserved wip nc}
    when "stock"
      %w{reserved wip nc}
    when "reserved"
      %w{wip stock nc}
    when "wip"
      %w{fg reserved stock nc}
    when "fg"
      %w{wip stock reserved nc}
    when "nc"
      %w{scrap stock reserved}
    when "scrap"
      %w{stock reserved nc}
    end
  end

  def qr_code
    @qr ||= RQRCode::QRCode.new(serial, size: 2, level: :h)
  end

  def set_area
    self.area = primary_dimension.area
  end

  private
  
  def upcase_shelf
    shelf.upcase! if shelf.present?
  end

  def reset_sales_order
    self.sales_order_id = nil
    self.order_fill_count = 1
  end

  def primary_dimension
    @primary_dimension ||= dimensions.first
  end

  def must_have_dimensions
    if dimensions.empty? || dimensions.all? {|dimension| dimension.marked_for_destruction? }
      errors.add(:base, 'Must have dimensions')
    end
  end
end
