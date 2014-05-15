class MasterFilm < ActiveRecord::Base
  include ActionView::Helpers::NumberHelper
  include Filterable
  include Tenancy

  DEFECT_TYPES = ['Air Bubble', 'Clear Spot', 'Dent', 'Dust/Dirt', 'Edge Delam', 'Non-Uniform', 'ROM', 'Wavy', 'Clear edges', 'BBL', 'Pickle', 'Short', 'White Spot', 'Spacer Spot', 'Clear Area', 'Dropper Mark', 'Foamy Streak', 'Streak', 'Thick Spot', 'Thick Material', 'Bend', 'Blocker Mark', 'BWS', 'Spacer Cluster', 'Glue Impression', 'Brown line', 'Scratch', 'Clear Peak', 'Material Traces', 'Small Clear']

  attr_accessible :serial, :effective_width, :effective_length, :formula, :mix_mass, :film_code, :machine_id, :thinky_code, :chemist, :operator, :inspector, :note, :defects, :micrometer_left, :micrometer_right, :run_speed

  has_many :films, dependent: :destroy
  belongs_to :machine

  before_validation :upcase_attributes
  before_validation :set_serial_date

  delegate :code, to: :machine, prefix: true, allow_nil: true

  validates :serial, presence: true, 
                     uniqueness: { case_sensitive: false, scope: :tenant_code },
                     format: { with: /\A[A-Z]\d{4}-\d{2}\z/ }

  scope :active, -> { all.joins(:films).merge(Film.active) }
  scope :serial_date_before, ->(date) { where('master_films.serial_date <= ?', date) }
  scope :serial_date_after, ->(date) { where('master_films.serial_date >= ?', date) }
  scope :by_serial, -> { order('master_films.serial DESC') }
  scope :formula_like, ->(formula) { where('formula ILIKE ?', formula.gsub('*', '%')) if formula.present? }
  scope :in_house, -> { where(in_house: true) }
  scope :text_search, ->(query) { reorder('').search(query) }
  
  include PgSearch
  pg_search_scope :search, 
    against: [:serial, :formula, :film_code, :thinky_code, :operator, :chemist, :inspector, :defects, :note], 
    using: { tsearch: { prefix: true } },
    associated_against: { machine: [:code] }

  def save_and_create_child(user)
    if save
      film = films.build(serial: "#{serial}-1", area: 0, tenant_code: tenant_code, division: 1, phase: "lamination")
      film.save!
      dimensions = film.dimensions.build(width: 0, length: 0)
      dimensions.save!
      movement = film.film_movements.build(from_phase: "raw", to_phase: "lamination", actor: user.full_name, tenant_code: tenant_code)
      movement.save!
    end
  end

  def self.date_range(start_date, end_date)
    start_serial = (start_date.year - 1943).chr + '%02d' % start_date.month + '%02d' % start_date.day + '-0'
    end_serial = (end_date.year - 1943).chr + '%02d' % end_date.month + '%02d' % (end_date.day+1) + '-0'
    serial_range(start_serial, end_serial)
  end

  def yield
    if effective_area && mix_mass && machine
      (100*tenant.yield_multiplier*(effective_area/mix_mass)/machine.yield_constant) 
    end
  end

  def effective_area
    AreaCalculator.calculate(effective_width, effective_length, tenant.area_divisor)
  end

  def defect_count(type)
    defects[type].to_i
  end

  def defects_sum
    defects.values.map(&:to_i).sum
  end

  def self.defect_types
    types = all.inject([]) do |arry, mf|
      arry + mf.defects.keys
    end
    types.uniq
  end

  def next_division
    films.pluck(:serial).map { |s| s[/.+-.+-(\d+)/, 1].to_i }.max + 1
  end

  def self.to_csv(options = {})
    types = defect_types
    CSV.generate(options) do |csv|
      csv << %w(Serial Formula Mix/g Machine ITO Thinky Chemist Operator Inspector EffW EffL) + types
      all.each do |mf|
        csv << [mf.serial, mf.formula, mf.mix_mass, mf.machine_code, mf.film_code, mf.thinky_code, mf.chemist, mf.operator, mf.inspector, mf.effective_width, mf.effective_length] + types.map{ |type| mf.defect_count(type) }
      end
    end
  end

  private

  def set_serial_date
    year = serial[0].ord + 1943
    month = serial[1,2].to_i
    day = serial[3,2].to_i
    self.serial_date = Date.new(year, month, day)
  rescue ArgumentError
    self.errors[:serial] = "does not correspond to a valid date"
  end
  
  def upcase_attributes
    formula.upcase! if formula.present?
    film_code.upcase! if film_code.present?
    thinky_code.upcase! if thinky_code.present?
    serial.upcase! if serial.present?
  end
end
