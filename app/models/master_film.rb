class MasterFilm < ActiveRecord::Base
  include Filterable
  include Tenancy

    DEFECT_TYPES = ['Air Bubble', 'BBL', 'Bend', 'Blocker Mark', 'Blotchy', 'Brown Line', 'BWS', 'Clear Area', 'Clear Edges', 'Clear Peak', 'Clear Spot', 'Clear Wavy Area', 'Dent', 'Dimball', 'Dimples', 'Dropper Mark', 'Delamination', 'Dust/Dirt/FOD', 'Edge Delam', 'Foamy Streak', 'Glue Impression', 'Knot', 'Material Traces', 'MD Line', 'Non-Uniform', 'Pickle', 'Peak', 'Repeating Defect', 'ROM', 'Scratch', 'Short', 'Small Clear', 'Spacer Cluster', 'Spacer Spot', 'Streak', 'Thick Spot', 'Thick Material', 'Transverse Line', 'Wavy', 'White Spot']

  enum function: [ :production, :test, :transfer ]

  has_many :films, dependent: :destroy
  belongs_to :machine

  before_validation :upcase_attributes, :set_serial_date
  before_save :set_yield
  after_update :update_film_serials, if: Proc.new { |mf| mf.serial_changed? }

  delegate :code, to: :machine, prefix: true, allow_nil: true
  alias_attribute :width, :effective_width
  alias_attribute :length, :effective_length

  validates :serial, presence: true, 
                     uniqueness: { case_sensitive: false, scope: :tenant_code },
                     format: { with: /\A[A-Z]\d{4}-\d{2}\z/ }
  validates :effective_width, numericality: { greater_than_or_equal_to: 0 }
  validates :effective_length, numericality: { greater_than_or_equal_to: :effective_width }

  scope :active, -> { all.joins(:films).merge(Film.not_deleted).uniq }
  scope :function, ->(function) { where(function: functions[function]) }
  scope :function_not, ->(function) { where("function <> ?", MasterFilm.functions[function]) }
  scope :serial_date_before, ->(date) { where('master_films.serial_date <= ?', date) }
  scope :serial_date_after, ->(date) { where('master_films.serial_date >= ?', date) }
  scope :by_serial, -> { order('master_films.serial DESC') }
  scope :formula_like, ->(formula) { where('formula ILIKE ?', formula.gsub('*', '%')) }
  scope :text_search, ->(query) { reorder('').search(query) }
  
  include PgSearch
  pg_search_scope :search, 
    against: [:serial, :formula, :film_code_top, :thinky_code, :operator, :chemist, :inspector, :defects, :note],
    using: { tsearch: { prefix: true } },
    associated_against: { machine: [:code] }

  def save_and_create_child(actor)
    if save
      film = create_film(:lamination)
      film.record_movement("raw", "lamination", actor)
    end
  end

  def create_film(phase, width = 0, length = 0)
    film = films.create!(serial: "#{serial}-#{next_division}", 
                         tenant_code: tenant_code, 
                         phase: phase)
    film.create_dimension(width, length)
    film.set_area
    film
  end

  def update_film_serials
    films.each do |f|
      div = f.serial[8..-1]
      f.update_columns(serial: serial + div)
    end
  end

  def effective_area
    effective_width*effective_length/tenant.area_divisor
  end

  def defect_count(type)
    defects[type].to_i
  end

  def self.defect_occurrences
    ary = defect_types.map do |t|
      [t, select { |mf| mf.defects[t] }.count]
    end
    Hash[ary]
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
    films.pluck(:serial).map { |s| s[/.+-.+-(\d+)/, 1].to_i }.max.to_i + 1
  end

  def self.total_effective_area
    all.map{ |mf| mf.effective_area }.sum
  end

  def self.avg_yield
    return nil if count == 0
    (all.map { |mf| mf.yield.to_f }.sum)/count
  end

  def self.to_csv(options = {})
    types = defect_types
    CSV.generate(options) do |csv|
      csv << %w(Serial Formula Mix/g Machine ITO Thinky b* Chemist Operator Inspector EffW EffL) + types
      all.each do |mf|
        csv << [mf.serial, mf.formula, mf.mix_mass, mf.machine_code, mf.film_code_top, mf.thinky_code, mf.b_value, mf.chemist, mf.operator, mf.inspector, mf.effective_width, mf.effective_length, mf.yield] + types.map{ |type| mf.defect_count(type) }
      end
    end
  end

  private

  def set_serial_date
    year = serial[0].ord + 1943
    month = serial[1,2].to_i
    day = serial[3,2].to_i
    self.serial_date = Date.new(year, month, day)
  rescue ArgumentError, NoMethodError
    self.errors[:serial] = "does not correspond to a valid date"
  end
  
  def upcase_attributes
    formula.upcase! if formula.present?
    film_code_top.upcase! if film_code_top.present?
    thinky_code.upcase! if thinky_code.present?
    serial.upcase! if serial.present?
  end

  def set_yield
    if yieldable?
      self.yield = (((((effective_width*effective_length)/144)/mix_mass)/machine.yield_constant)*100)
    else
      self.yield = nil
    end
  end

  def yieldable?
    mix_mass && machine
  end
end
