class Defect < ActiveRecord::Base
  attr_accessible :defect_type, :count
  belongs_to :master_film

  delegate :serial, to: :master_film, prefix: true, allow_nil: true

  validates :defect_type, presence: true
  validates :count, numericality: { greater_than: 0 }

  def self.allowed_types
    ['Air Bubble', 'Clear Spot', 'Dent', 'Dust/Dirt', 'Edge Delam', 'Non-Uniform', 'ROM', 'Wavy', 'Clear edges', 'BBL', 'Pickle', 'Short', 'White Spot', 'Spacer Spot', 'Clear Area', 'Dropper Mark', 'Foamy Streak', 'Streak', 'Thick Spot', 'Thick Material', 'Bend', 'Blocker Mark', 'BWS', 'Spacer Cluster', 'Glue Impression', 'Brown line', 'Scratch', 'Clear Peak', 'Material Traces', 'Small Clear']
  end

  def self.to_csv(options = {})
    CSV.generate(options) do |csv|
      csv << %w(Serial Type Count)
      all.includes(:master_film).order('master_films.serial DESC').each do |d|
        csv << [d.master_film_serial, d.defect_type, d.count] 
      end
    end
  end
end
