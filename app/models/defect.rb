class Defect < ActiveRecord::Base
  attr_accessible :defect_type, :count
  belongs_to :master_film

  validates :defect_type, presence: true
  validates :count, numericality: { greater_than_or_equal_to: 0 }

  def self.allowed_types
    ['Air Bubble', 'Clarity', 'Clear Spot', 'Dent', 'Dust/Dirt', 'Edge Delam', 'Non-Uniform', 'Pickle', 'Short', 'White Spot', 'Spacer Spot', 'Clear Area', 'Dropper Mark', 'Foamy Streak', 'Streak', 'Thick Spot', 'Thick Material', 'Bend', 'Blocker Mark', 'BWS']
  end

  def self.import(file)
    CSV.foreach(file.path, headers: true) do |row|
      record = Defect.new(row.to_hash, without_protection: true)
      record.save!(validate: false)
    end
    ActiveRecord::Base.connection.execute("SELECT setval('defects_id_seq', (SELECT MAX(id) FROM defects));")
  end
end
