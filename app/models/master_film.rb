class MasterFilm < ActiveRecord::Base
  attr_accessible :serial, :formula, :mix_mass, :film_code, :machine_id,
    :thinky_code, :chemist, :operator, :effective_width,
    :effective_length, :note, :films_attributes, :defects_attributes

  has_many :films
  has_many :defects
  belongs_to :machine

  after_save :update_defects_sum

  accepts_nested_attributes_for :defects, allow_destroy: true
  accepts_nested_attributes_for :films

  delegate :code, to: :machine, prefix: true, allow_nil: true

  validates :serial, presence: true, uniqueness: { case_sensitive: false },
    format: { with: /\A[A-Z]\d{4}-\d{2}\z/, on: :create }

  scope :active, -> { includes(:films).where(films: { deleted: false }) }
  scope :by_serial, -> { order('serial DESC') }

  def effective_area
    (effective_width*effective_length/144).round(2) if effective_width && effective_length
  end

  def yield
    (100*(effective_area/mix_mass)/machine.yield_constant).round(2) if effective_area && mix_mass && machine
  end

  def laminated_at
    year = serial[0].ord + 1943
    month = serial[1,2].to_i
    day = serial[3,2].to_i
    DateTime.new(year, month, day)
  end

  def self.to_csv(options = {})
    CSV.generate(options) do |csv|
      csv << %w(Serial Formula Mix/g Machine ITO Thinky Chemist Operator EffW EffL Area Yield Defects)
      all.each do |mf|
        csv << [mf.serial, mf.formula, mf.mix_mass, mf.machine_code, mf.film_code, 
                mf.thinky_code, mf.chemist, mf.operator, mf.effective_width, 
                mf.effective_length, mf.effective_area, mf.yield, mf.defects_sum] 
      end
    end
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

private
  
  def update_defects_sum
    update_column(:defects_sum, defects.sum(:count))
  end
end
