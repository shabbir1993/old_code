class Film < ActiveRecord::Base
  include Filterable
  include Tenancy

  attr_accessible :note, :shelf, :phase, :deleted, :sales_order_id, :order_fill_count, :master_film_id, :tenant_code, :serial, :dimensions_attributes, :area
  attr_reader :destination

  belongs_to :master_film
  belongs_to :sales_order
  has_many :film_movements
  has_many :dimensions, -> { order('id ASC') }

  accepts_nested_attributes_for :dimensions, allow_destroy: true, reject_if: proc { |attributes| attributes['width'].blank? || attributes['length'].blank? }

  delegate :formula, to: :master_film
  delegate :code, to: :sales_order, prefix: true, allow_nil: true
  delegate :width, :length, to: :primary_dimension

  before_save :upcase_shelf, :set_area

  validates :phase, presence: true
  validates :order_fill_count, numericality: { greater_than: 0 }
  validate :must_have_dimensions, on: :update

  scope :join_dimensions, -> { joins('LEFT OUTER JOIN dimensions ON dimensions.film_id = films.id').uniq }
  scope :join_master_films, -> { joins('INNER JOIN master_films ON master_films.id = films.master_film_id') }
  scope :active, -> { where(deleted: false)
                     .join_master_films
                     .merge(MasterFilm.where("function <> ?", MasterFilm.functions[:test])) }
  scope :deleted, -> { where(deleted: true) }
  scope :not_deleted, -> { where(deleted: false) }
  scope :large, ->(cutoff) { join_dimensions.merge(Dimension.large(cutoff)) }
  scope :small, ->(cutoff) { join_dimensions.merge(Dimension.small(cutoff)) }
  scope :reserved, -> { where("sales_order_id IS NOT NULL") }
  scope :available, -> { where("sales_order_id IS NULL") }
  scope :text_search, ->(query) { reorder('').search(query) }
  scope :formula_like, ->(formula) { join_master_films
                                    .merge(MasterFilm.formula_like(formula)) }
  scope :order_by, ->(col, dir) { order("#{col} #{dir}") }
  scope :width_greater_than, ->(n) { join_dimensions.merge(Dimension.min_width(n)) }
  scope :length_greater_than, ->(n) { join_dimensions.merge(Dimension.min_length(n)) }

  include PgSearch
  pg_search_scope :search, 
    against: [:serial, :note, :shelf, :phase], 
    using: { tsearch: { prefix: true } },
    associated_against: { master_film: [:formula], sales_order: [:code] }

  def split
    split = master_film.films.build(serial: "#{master_film.serial}-#{master_film.next_division}", area: area, tenant_code: tenant_code, phase: phase).tap(&:save!)
    split.dimensions.build(width: width, length: length).save!
    split
  end

  def update_and_move(attrs, destination, user)
    before_phase = phase
    if update_attributes(attrs)
      if PhaseDefinitions.front_end?(before_phase)
        master_film.effective_width = width
        master_film.effective_length = length
        master_film.save!
      end
      move_to(destination, user) if destination.present?
    end
  end

  def self.phase(phase, tenant = nil)
    case phase
    when "lamination", "inspection", "stock", "wip", "fg", "nc", "scrap"
      active.where(phase: phase)
    when "large_stock"
      phase("stock").large(tenant.small_area_cutoff).available
    when "small_stock"
      phase("stock").small(tenant.small_area_cutoff).available
    when "reserved_stock"
      phase("stock").reserved
    when "deleted"
      deleted
    end
  end

  def unassign
    reset_sales_order
    save!
  end

  def self.total_order_fill_count
    all.sum(:order_fill_count)
  end

  def move_to(destination, user)
    reset_sales_order unless %w(stock wip fg).include?(destination)
    self.phase = destination
    movement = film_movements.build(from_phase: phase_was, to_phase: destination, width: width, length: length, actor: user.full_name, tenant_code: tenant_code)
    save!
    movement.save!
  end

  def phase_label_class
    case phase
    when "wip"
      "label-warning"
    when "fg"
      "label-success"
    else
      "label-danger"
    end
  end

  def moved_to
    if deleted?
      "deleted"
    else
      phase
    end
  end

  def moved?
    previous_changes.keys.include?("phase")
  end

  def self.total_area
    sum(:area)
  end

  def self.to_csv(options = {})
    CSV.generate(options) do |csv|
      csv << %w(Serial Formula Width Length Area Shelf SO Phase)
      all.join_dimensions.each do |f|
        csv << [f.serial, f.formula, f.width, f.length, f.area, f.shelf, f.sales_order_code, f.phase]
      end
    end
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

  def set_area
    self.area = primary_dimension.area
  end
end
