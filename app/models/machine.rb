class Machine < ActiveRecord::Base
  attr_accessible :code 
  validates :code, presence: true
  validates :yield_constant, presence: true

  def self.import(file)
    CSV.foreach(file.path, headers: true) do |row|
      record = Machine.new(row.to_hash, without_protection: true)
      record.save!(validate: false)
    end
    ActiveRecord::Base.connection.execute("SELECT setval('machines_id_seq', (SELECT MAX(id) FROM machines));")
  end
end
