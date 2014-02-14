class User < ActiveRecord::Base
  attr_accessible :username, :full_name, :password, :password_confirmation, :chemist, :operator, :role_level

  has_secure_password

  has_many :film_movements

  validates :username, presence: true, uniqueness: { case_sensitive: false }
  validates :full_name, presence: true, uniqueness: { case_sensitive: false }

  def self.chemists
    User.where(chemist: true).pluck(:full_name)
  end

  def self.operators
    User.where(operator: true).pluck(:full_name)
  end

  def is_admin?
    role_level == 1
  end

  def tenant
    @tenant || Tenant.new(tenant_code)
  end
end
