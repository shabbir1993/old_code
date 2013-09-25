class MasterFilm < ActiveRecord::Base
  attr_accessible :serial, :formula, :mix_mass, :film_code, :machine_id,
    :thinky_code, :chemist_id, :operator_id, :effective_width,
    :effective_length, :films_attributes, :defects_attributes

  has_many :films
  has_many :defects
  belongs_to :machine
  belongs_to :chemist, class_name: "User"
  belongs_to :operator, class_name: "User"

  accepts_nested_attributes_for :defects, allow_destroy: true
  accepts_nested_attributes_for :films, 
    reject_if: proc { |attr| attr['width'].blank? || attr['length'].blank? }

  delegate :code, to: :machine, prefix: true, allow_nil: true
  delegate :name, to: :chemist, prefix: true, allow_nil: true
  delegate :name, to: :operator, prefix: true, allow_nil: true

  validates :serial, presence: true, uniqueness: { case_sensitive: false },
    format: { with: /^[A-Z]\d{4}-\d{2}$/, on: :create }

  scope :by_serial, order('serial DESC')

  def effective_area
    effective_width*effective_length/144 if effective_width && effective_length
  end

  def yield
    (effective_area/mix_mass)/machine.yield_constant if effective_area && mix_mass && machine
  end

  def laminated_at
    year = serial[0].ord + 1943
    month = serial[1,2].to_i
    day = serial[3,2].to_i
    DateTime.new(year, month, day)
  end

  def defect_count
    defects.sum(:count)
  end

  def self.import(file)
    CSV.foreach(file.path, headers: true) do |row|
      record = MasterFilm.new(row.to_hash, without_protection: true)
      record.save!(validate: false)
    end
    ActiveRecord::Base.connection.execute("SELECT setval('master_films_id_seq', (SELECT MAX(id) FROM master_films));")
  end
end
