class User < ActiveRecord::Base
  attr_accessible :email, :name, :chemist, :operator
  validates :email, presence: true
  validates :name, presence: true

  scope :chemists, where(chemist: true)
  scope :operators, where(operator:true)

  def self.import(file)
    CSV.foreach(file.path, headers: true) do |row|
      record = User.new(row.to_hash, without_protection: true)
      record.save!(validate: false)
    end
  end
end
