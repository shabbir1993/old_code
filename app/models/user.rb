class User < ActiveRecord::Base
  attr_accessible :username, :full_name, :password, :password_confirmation, :chemist, :operator, :active, :role_level

  has_secure_password

  has_many :film_movements

  validates :username, presence: true
  validates :full_name, presence: true

  scope :chemists, where(chemist: true)
  scope :operators, where(operator:true)

  def is_supervisor?
    role_level >= 1
  end

  def is_admin?
    role_level >= 2
  end

  def self.import(file)
    CSV.foreach(file.path, headers: true) do |row|
      record = User.new(row.to_hash, without_protection: true)
      record.save!(validate: false)
    end
    ActiveRecord::Base.connection.execute("SELECT setval('users_id_seq', (SELECT MAX(id) FROM users));")
  end
end
