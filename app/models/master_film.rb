class MasterFilm < ActiveRecord::Base
  attr_accessible :date_code, :formula, :number, :mix_mass, :film_code, :machine_id,  :thinky_code, :chemist_id, :operator_id, :effective_width, :effective_length, :films_attributes, :defects_attributes

  has_many :films
  has_many :defects
  belongs_to :machine
  belongs_to :chemist, class_name: "User"
  belongs_to :operator, class_name: "User"

  accepts_nested_attributes_for :defects, allow_destroy: true
  accepts_nested_attributes_for :films, allow_destroy: true

  delegate :code, to: :machine, prefix: true, allow_nil: true
  delegate :name, to: :chemist, prefix: true, allow_nil: true
  delegate :name, to: :operator, prefix: true, allow_nil: true

  after_create :create_child_film
  
  validates :date_code, presence: true,
                        uniqueness: { scope: :number,
                                      message: "serial has already been taken" }
  validates :number, presence: true
  validates :formula, presence: true
  validates :effective_width, :effective_length, 
                              numericality: { greater_than_or_equal_to: 0, 
                                              allow_nil: true }

  def master_serial
    date_code + "-" + format('%02d', number) + formula
  end

  def effective_area
    effective_width*effective_length/144 if effective_width && effective_length
  end

  def defect_count
    defects.sum(:count)
  end

  def self.import(file)
    skip_callback(:create, :after, :create_child_film)
    CSV.foreach(file.path, headers: true) do |row|
      record = MasterFilm.new(row.to_hash, without_protection: true)
      record.save!(validate: false)
    end
    set_callback(:create, :after, :create_child_film)
  end

private
  
  def create_child_film
    child_film = self.films.build
    child_film.save
  end
end
