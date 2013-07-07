class MasterFilm < ActiveRecord::Base
  attr_accessible :serial, :formula, :mix_mass, :film_code, :machine_id,  :thinky_code, :chemist_id, :operator_id, :effective_width, :effective_length, :films_attributes, :defects_attributes

  has_many :films
  has_many :defects
  belongs_to :machine
  belongs_to :chemist, class_name: "User"
  belongs_to :operator, class_name: "User"

  accepts_nested_attributes_for :defects, allow_destroy: true,
                                          reject_if: proc { |attr| attr['defect_type'].blank? }
  accepts_nested_attributes_for :films, reject_if: proc { |attr| attr['width'].blank? || attr['length'].blank? }

  delegate :code, to: :machine, prefix: true, allow_nil: true
  delegate :name, to: :chemist, prefix: true, allow_nil: true
  delegate :name, to: :operator, prefix: true, allow_nil: true

  validates :serial, presence: true, uniqueness: { case_sensitive: false }

  def effective_area
    effective_width*effective_length/144 if effective_width && effective_length
  end

  def defect_count
    defects.sum(:count)
  end

  def self.import(file)
    CSV.foreach(file.path, headers: true) do |row|
      record = MasterFilm.new(row.to_hash, without_protection: true)
      record.save!(validate: false)
    end
  end
end
