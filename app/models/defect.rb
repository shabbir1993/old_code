class Defect < ActiveRecord::Base
  attr_accessible :defect_type, :count
  belongs_to :master_film

  validates :defect_type, presence: true
  validates :count, numericality: { greater_than_or_equal_to: 0 }
  validates :master_film_id, presence: true

  def self.allowed_types
    ['white spot']
  end

  def self.import(file)
    CSV.foreach(file.path, headers: true) do |row|
      record = Defect.new(row.to_hash, without_protection: true)
      record.save!(validate: false)
    end
  end
end
