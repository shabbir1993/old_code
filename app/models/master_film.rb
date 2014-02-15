class MasterFilm < ActiveRecord::Base
  include Importable

  DEFECT_TYPES = ['Air Bubble', 'Clear Spot', 'Dent', 'Dust/Dirt', 'Edge Delam', 'Non-Uniform', 'ROM', 'Wavy', 'Clear edges', 'BBL', 'Pickle', 'Short', 'White Spot', 'Spacer Spot', 'Clear Area', 'Dropper Mark', 'Foamy Streak', 'Streak', 'Thick Spot', 'Thick Material', 'Bend', 'Blocker Mark', 'BWS', 'Spacer Cluster', 'Glue Impression', 'Brown line', 'Scratch', 'Clear Peak', 'Material Traces', 'Small Clear']

  attr_accessible :serial, :effective_width, :effective_length, :formula, :mix_mass, :film_code, :machine_id, :thinky_code, :chemist, :operator, :note, :defects

  has_many :films
  belongs_to :machine

  before_validation :upcase_attributes

  delegate :code, to: :machine, prefix: true, allow_nil: true

  validates :serial, presence: true, uniqueness: { case_sensitive: false, scope: :tenant_code },
    format: { with: /\A[A-Z]\d{4}-\d{2}\z/ }

  scope :active, -> { includes(:films).where(films: { deleted: false }) }
  scope :by_serial, -> { order('serial DESC') }

  def save_and_create_child(user)
    if save
      film = films.build(tenant_code: tenant_code, division: 1, phase: "lamination")
      movement = film.film_movements.build(from_phase: "raw", to_phase: "lamination", actor: user.full_name, tenant_code: tenant_code)
      film.save!
      movement.save!
    end
  end

  def yield
    (100*tenant.yield_multiplier*(effective_area/mix_mass)/machine.yield_constant) if effective_area && mix_mass && machine
  end

  def effective_area
    AreaCalculator.calculate(effective_width, effective_length, tenant.area_divisor)
  end

  def laminated_at
    year = serial[0].ord + 1943
    month = serial[1,2].to_i
    day = serial[3,2].to_i
    DateTime.new(year, month, day)
  end

  def defect_count(type)
    defects[type].to_i
  end
  
  def upcase_attributes
    formula.upcase! if formula.present?
    film_code.upcase! if film_code.present?
    thinky_code.upcase! if thinky_code.present?
    serial.upcase! if serial.present?
  end

  def defects_sum
    defects.values.map(&:to_i).sum
  end

  def self.search(start_serial, end_serial)
    master_films = all
    if start_serial
      master_films = master_films.where("serial >= ?", start_serial)
    end
    if end_serial
      master_films = master_films.where("serial <= ?", end_serial)
    end
    master_films
  end

  def self.defect_types
    types = all.inject([]) do |arry, mf|
      arry + mf.defects.keys
    end
    types.uniq
  end

  def tenant
    @tenant ||= Tenant.new(tenant_code)
  end

  def max_division
    films.pluck(:division).max.to_i
  end
end
