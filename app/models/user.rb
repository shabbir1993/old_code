class User < ActiveRecord::Base
  attr_accessible :username, :full_name, :password, :password_confirmation, :chemist, :operator, :role_level, :inspector

  has_secure_password

  validates :username, presence: true, uniqueness: { case_sensitive: false }
  validates :full_name, presence: true, uniqueness: { case_sensitive: false }

  scope :tenant, ->(code) { where(tenant_code: code) }

  enum role_level: [ :user, :admin ]

  def self.chemists
    User.where(chemist: true).pluck(:full_name)
  end

  def self.operators
    User.where(operator: true).pluck(:full_name)
  end

  def self.inspectors
    User.where(inspector: true).pluck(:full_name)
  end

  def tenant
    @tenant || Tenant.new(tenant_code)
  end

  # explicit database column definitions as workaround for verifying doubles with rspec-mocks
  def full_name; super; end
  def tenant_code; super; end
  def tenant_code=(arg); super(arg); end
end
