class User < ActiveRecord::Base
  attr_accessible :username, :full_name, :password, :password_confirmation, :chemist, :operator, :role_level

  has_secure_password

  has_many :film_movements

  validates :username, presence: true
  validates :full_name, presence: true

  def self.chemists
    User.where(chemist: true).pluck(:full_name)
  end

  def self.operators
    User.where(operator: true).pluck(:full_name)
  end

  def is_supervisor?
    role_level >= 1
  end

  def is_admin?
    role_level >= 2
  end

  def role_title
    case role_level
    when 0
      "User"
    when 1
      "Supervisor"
    when 2
      "Admin"
    else
      "Undefined"
    end
  end
end
