class Film < ActiveRecord::Base
  include Importable

  SECOND_WIDTH_SQL = "substring(films.note from '([0-9]+([.][0-9]+)?)[ ]*[xX][ ]*([0-9]+([.][0-9]+)?)')::decimal"
  SECOND_LENGTH_SQL = "substring(films.note from '(?:[0-9]+(?:[.][0-9]+)?)[ ]*[xX][ ]*([0-9]+([.][0-9]+)?)')::decimal"

  attr_accessible :width, :length, :note, :shelf, :phase, :deleted, :sales_order_id, :order_fill_count, :master_film_id, :tenant_code, :division
  attr_reader :destination

  belongs_to :master_film
  belongs_to :sales_order
  has_many :film_movements

  delegate :formula, to: :master_film
  delegate :code, to: :sales_order, prefix: true, allow_nil: true

  before_save :upcase_shelf

  validates :phase, presence: true
  validates :width, :length, presence: true, 
    unless: lambda { |film| PhaseDefinitions.front_end?(film.phase) }
  validates :order_fill_count, numericality: { greater_than: 0 }

  include PgSearch
  pg_search_scope :search, 
    against: [:division, :note, :shelf, :phase], 
    using: { tsearch: { prefix: true } },
    associated_against: { master_film: [:serial, :formula], sales_order: [:code] }

  scope :active, -> { where(deleted: false) }
  scope :deleted, -> { where(deleted: true) }
  scope :phase, ->(phase) { where(phase: phase) }
  scope :small, ->(cutoff) { where("width*length < ?", cutoff) }
  scope :large, ->(cutoff) { where("width*length >= ? or width IS NULL or length IS NULL", cutoff) }
  scope :reserved, -> { where("sales_order_id IS NOT NULL") }
  scope :not_reserved, -> { where("sales_order_id IS NULL") }

  scope :with_additional_fields, ->(area_divisor) { 
    joins("LEFT OUTER JOIN master_films ON master_films.id = films.master_film_id")
    .joins("LEFT OUTER JOIN sales_orders ON sales_orders.id = films.sales_order_id")
    .select("films.*, 
            master_films.serial || '-' || films.division as serial, 
            width*length/#{area_divisor} as area, 
            sales_orders.code as sales_order_code, 
            #{SECOND_WIDTH_SQL} as second_width, 
            #{SECOND_LENGTH_SQL} as second_length") }

  def serial
    "#{master_film.serial}-#{division}"
  end

  def area
    AreaCalculator.calculate(width, length, tenant.area_divisor)
  end

  def split
    division = master_film.films.pluck(:division).max.to_i + 1
    master_film.films.build(tenant_code: tenant_code, 
                            division: division,
                            phase: phase, 
                            width: width, 
                            length: length).tap(&:save!)
  end

  def update_and_move(attrs, destination, user)
    before_phase = phase
    if update_attributes(attrs)
      if PhaseDefinitions.front_end?(before_phase)
        master_film.effective_width = attrs[:width]
        master_film.effective_length = attrs[:length]
        master_film.save!
      end
      move_to(destination, user) if destination.present?
    end
  end

  def unassign
    reset_sales_order
    save!
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
    if min_width.present? && min_length.present?
      all.where("width >= :min_width AND length >= :min_length OR #{SECOND_WIDTH_SQL} >= :min_width AND #{SECOND_LENGTH_SQL} >= :min_length", { min_width: min_width, min_length: min_length } )
    elsif min_width.present?
      all.where("width >= :min_width OR #{SECOND_WIDTH_SQL} >= :min_width", min_width: min_width)
    elsif min_length.present?
      all.where("length >= :min_length OR #{SECOND_LENGTH_SQL} >= :min_length", min_length: min_length)
    else
      all
    end
  end

  def move_to(destination, user)
    reset_sales_order if %w(stock wip fg).include?(destination)
    self.phase = destination
    save!
    movement = film_movements.build(from_phase: phase, to_phase: destination, width: width, length: length, actor: user.full_name, tenant_code: tenant_code)
    movement.save!
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
