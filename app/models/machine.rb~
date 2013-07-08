class Machine < ActiveRecord::Base
  attr_accessible :code 
  validates :code, presence: true

  def self.import(file)
    CSV.foreach(file.path, headers: true) do |row|
      record = Machine.new(row.to_hash, without_protection: true)
      record.save!(validate: false)
    end
  end
end
