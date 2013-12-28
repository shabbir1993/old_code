class MasterFilm < ActiveRecord::Base
  attr_accessible :serial, :formula, :mix_mass, :film_code, :machine_id,
    :thinky_code, :chemist, :operator, :effective_width,
    :effective_length, :note, :films_attributes, :defects_attributes

  has_many :films
  has_many :defects
  belongs_to :machine
  belongs_to :tenant

  before_validation :upcase_attributes
  after_save :update_defects_sum

  accepts_nested_attributes_for :defects, allow_destroy: true
  accepts_nested_attributes_for :films

  delegate :code, to: :machine, prefix: true, allow_nil: true

  validates :serial, presence: true, uniqueness: { case_sensitive: false, scope: :tenant_id },
    format: { with: /\A[A-Z]\d{4}-\d{2}\z/ }

  default_scope { where(tenant_id: Tenant.current_id) }
  scope :active, -> { includes(:films).where(films: { deleted: false }) }
  scope :by_serial, -> { order('serial DESC') }

  def effective_area
    (effective_width*effective_length/Tenant.find(Tenant.current_id).area_divisor).round(2) if effective_width && effective_length
  end
  
  def effective_width=(effective_width)
    if films.count == 1 && films.first.width.nil?
      films.first.update_attributes(width: effective_width)
    end
    self[:effective_width] = effective_width
  end

  def effective_length=(effective_length)
    if films.count == 1 && films.first.length.nil?
      films.first.update_attributes(length: effective_length)
    end
    self[:effective_length] = effective_length
  end

  def old_yield
    (100*Tenant.find(Tenant.current_id).yield_multiplier*(effective_area/mix_mass)/machine.yield_constant).round(2) if effective_area && mix_mass && machine
  end

  def new_yield
    (100*Tenant.find(Tenant.current_id).yield_multiplier*(new_effective_area/mix_mass)/machine.yield_constant).round(2) if new_effective_area && mix_mass && machine
  end

  def new_effective_area
    films.map { |f| f.area.to_f }.sum
  end

  def laminated_at
    year = serial[0].ord + 1943
    month = serial[1,2].to_i
    day = serial[3,2].to_i
    DateTime.new(year, month, day)
  end

  def self.to_csv(options = {})
    defect_types = defects.pluck(:defect_type).uniq
    CSV.generate(options) do |csv|
      header = %w(Serial Formula Mix/g Machine ITO Thinky Chemist Operator EffW EffL Area OldYield NewYield Defects) + defect_types
      csv << header
      all.includes(:defects).each do |mf|
        row = [mf.serial, mf.formula, mf.mix_mass, mf.machine_code, mf.film_code, 
                mf.thinky_code, mf.chemist, mf.operator, mf.effective_width, 
                mf.effective_length, mf.effective_area, mf.old_yield, mf.new_yield, mf.defects_sum] + defect_types.map{ |type| mf.defect_count(type) }
        csv << row
      end
    end
  end

  def defect_count(type)
    defects_of_type = defects.where(defect_type: type)
    if defects_of_type.any?
      defects_of_type.sum(:count)
    else
      0
    end
  end
  
  def upcase_attributes
    formula.upcase! if formula.present?
    film_code.upcase! if film_code.present?
    thinky_code.upcase! if thinky_code.present?
    serial.upcase! if serial.present?
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

  def self.defects
    master_film_ids = all.pluck(:id)
    Defect.where("master_film_id IN (?)", master_film_ids)
  end

private
  
  def update_defects_sum
    update_column(:defects_sum, defects.sum(:count))
  end
end
