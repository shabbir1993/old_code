class Film < ActiveRecord::Base
  attr_accessible :destination, :width, :length, :custom_width, :custom_length,
    :reserved_for, :note, :sales_order_code, :customer, :shelf,
    :master_film_attributes, :splits, :effective_width, :effective_length,
    :phase, :deleted

  belongs_to :master_film
  has_many :film_movements

  delegate :formula, :mix_mass, :film_code, :thinky_code, :machine_code,
    :chemist_full_name, :operator_full_name, :effective_width, :effective_length,
    :effective_area, :defect_count, to: :master_film

  accepts_nested_attributes_for :master_film

  before_create :set_division

  validates :phase, presence: true

  default_scope where(deleted: false)
  scope :phase, lambda { |phase| where(phase: phase) }
  scope :by_serial, joins(:master_film).order('master_films.serial DESC, division ASC')
  scope :small, where('width*length/144 < ?', 16)
  scope :large, where('width*length/144 >= ? or width IS NULL or length IS NULL', 16)
  scope :reserved, where("reserved_for <> ''")
  scope :not_reserved, where("reserved_for IS NULL or reserved_for = ''")
  scope :lamination, phase("lamination").by_serial
  scope :inspection, phase("inspection").by_serial
  scope :large_stock, phase("stock").large.not_reserved.by_serial
  scope :small_stock, phase("stock").small.not_reserved.by_serial
  scope :reserved_stock, phase("stock").reserved.by_serial
  scope :wip, phase("wip").by_serial
  scope :fg, phase("fg").by_serial
  scope :test, phase("test").by_serial
  scope :nc, phase("nc").by_serial
  scope :scrap, phase("scrap").by_serial
  scope :deleted, unscoped.where(deleted: true).by_serial

  def destination
  end

  def destination=(to_phase)
    if to_phase.present?
      from_phase = to_phase == "lamination" ? "raw material" : phase
      self.phase = to_phase
      movement = film_movements.build(from: from_phase, to: to_phase, area: area)
      movement.save!
    end
  end

  def effective_width=(width)
    if width.present?
      self.width = width
      master_film.effective_width = width
    end
  end

  def effective_length=(length)
    if length.present?
      self.length = length
      master_film.effective_length = length
    end
  end

  def serial
    master_film.serial + "-" + division.to_s
  end

  def area
    width * length / 144 if width && length
  end

  def custom_area
    custom_width * custom_length / 144 if custom_width && custom_length
  end

  def utilization
    custom_area / area if custom_area && area
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
      films = scoped
      films = films.where("width >= ?", min_width) if min_width.present?
      films = films.where("width <= ?", max_width) if max_width.present?
      films = films.where("length >= ?", min_length) if min_length.present?
      films = films.where("length <= ?", max_length) if max_length.present?
      films
    else
      scoped
    end
  end

  def self.import(file)
    CSV.foreach(file.path, headers: true) do |row|
      record = Film.new(row.to_hash, without_protection: true)
      record.save!(validate: false)
    end
    ActiveRecord::Base.connection.execute("SELECT setval('films_id_seq',
                                          (SELECT MAX(id) FROM films));") 
  end
end
