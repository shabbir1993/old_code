class Film < ActiveRecord::Base
  include Exportable
  include Importable

  SECOND_WIDTH_SQL = "substring(films.note from '([0-9]+([.][0-9]+)?)[ ]*[xX][ ]*([0-9]+([.][0-9]+)?)')::decimal"
  SECOND_LENGTH_SQL = "substring(films.note from '(?:[0-9]+(?:[.][0-9]+)?)[ ]*[xX][ ]*([0-9]+([.][0-9]+)?)')::decimal"

  attr_accessible :width, :length, :note, :shelf, :phase, :deleted, :sales_order_id, :order_fill_count, :master_film_id, :tenant_code
  attr_reader :destination

  belongs_to :master_film
  belongs_to :sales_order
  has_many :film_movements

  delegate :formula, to: :master_film
  delegate :code, to: :sales_order, prefix: true, allow_nil: true

  before_create :set_division
  before_save :upcase_shelf

  validates :phase, presence: true
  validates :width, :length, presence: true, unless: lambda { |film| PhaseDefinitions.front_end?(film.phase) }
  validates :order_fill_count, numericality: { greater_than: 0 }

  include PgSearch
  pg_search_scope :search, against: [:division, :note, :shelf, :phase], 
    :using => { tsearch: { prefix: true } },
    associated_against: {
      master_film: [:serial, :formula],
      sales_order: [:code]
    }

  scope :active, -> { where(deleted: false) }
  scope :deleted, -> { where(deleted: true) }
  scope :phase, ->(phase) { where(phase: phase) }
  scope :small, ->(cutoff) { where("width*length < ?", cutoff) }
  scope :large, ->(cutoff) { where("width*length >= ? or width IS NULL or length IS NULL", cutoff) }
  scope :reserved, -> { where("sales_order_id IS NOT NULL") }
  scope :not_reserved, -> { where("sales_order_id IS NULL") }
  scope :min_width, ->(width = 0) { where("width >= ?", width) }
  scope :min_length, ->(length = 0) { where("length >= ?", length) }
  scope :with_area, ->(area_divisor) { select("films.*, width*length/#{area_divisor} as area") }
  scope :with_sortable_fields, -> { joins("LEFT OUTER JOIN master_films ON master_films.id = films.master_film_id")
                                    .joins("LEFT OUTER JOIN sales_orders ON sales_orders.id = films.sales_order_id")
                                    .select("films.*, 
                                            master_films.serial || '-' || films.division as serial, 
                                            sales_orders.code as sales_order_code, 
                                            #{SECOND_WIDTH_SQL} as second_width, 
                                            #{SECOND_LENGTH_SQL} as second_length") }

  def serial
    "#{master_film.serial}-#{division}"
  end

    def area
      AreaCalcuator.calculate(width, length, tenant.area_divisor)
    end

  def split
    master_film.films.build(tenant_code: tenant_code, 
                            phase: phase, 
                            width: width, 
                            length: length).tap(&:save!)
  end

  def update_and_move(attrs, destination, user)
    movement = nil
    assign_attributes(attrs)
    if PhaseDefinitions.front_end?(phase)
      master_film.effective_width = attrs[:width]
      master_film.effective_length = attrs[:length]
    end
    if destination.present?
      reset_sales_order if %w(stock wip fg).include?(destination)
      self.phase = destination
      movement = build_movement(destination, user)
    end
    if valid?
      save!
      movement.save! if movement
      master_film.save!
    end
  end

  def unassign
    reset_sales_order
    save!
  end
  
  def area
    AreaCalculator.calculate(width, length, tenant.area_divisor)
  end

  def self.total_area
    all.map{ |f| f.area.to_f }.sum
  end

  def set_division
    self.division ||= (master_film.films.pluck(:division).max.to_i) + 1
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
    if min_width.present? && min_length.present?
      results = results.where("width >= :min_width AND length >= :min_length OR #{SECOND_WIDTH_SQL} >= :min_width AND #{SECOND_LENGTH_SQL} >= :min_length", { min_width: min_width, min_length: min_length } )
    else
      results = results.where("width >= :min_width OR #{SECOND_WIDTH_SQL} >= :min_width", min_width: min_width) if min_width.present?
      results = results.where("length >= :min_length OR #{SECOND_LENGTH_SQL} >= :min_length", min_length: min_length) if min_length.present?
    end
    results
  end

  def self.data_for_export
    data = [] << %w(Serial Formula Width Length Area Shelf SO Phase)
    all.limit(5000).each do |f|
      data << [f.serial, f.formula, f.width, f.length, f.area, f.shelf, f.sales_order_code, f.phase]
    end
    data
  end

  def build_movement(destination, user)
    from_phase = phase || "raw"
    film_movements.build(from_phase: from_phase, to_phase: destination, width: width, length: length, actor: user.full_name, tenant_code: tenant_code)
  end

  def tenant
    @tenant ||= Tenant.new(tenant_code)
  end

  private
  
  def upcase_shelf
    shelf.upcase! if shelf.present?
  end

  def reset_sales_order
    assign_attributes(sales_order_id: nil, order_fill_count: 1)
  end
end
