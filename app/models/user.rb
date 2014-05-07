class User < ActiveRecord::Base
  include Tenancy

  attr_accessible :username, :full_name, :password, :password_confirmation, :chemist, :operator, :role_level, :inspector

  has_secure_password

  validates :username, presence: true, uniqueness: { case_sensitive: false }
  validates :full_name, presence: true, uniqueness: { case_sensitive: false }

  scope :chemists, -> { where(chemist: true) }
  scope :operators, -> { where(operator: true) }
  scope :inspectors, -> { where(inspector: true) }

  enum role_level: [ :user, :admin ]

  def self.names
    pluck(:full_name)
  end
end
