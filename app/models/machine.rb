class Machine < ActiveRecord::Base
  attr_accessible :code, :yield_constant, :tenant_code
  validates :code, presence: true
  validates :yield_constant, presence: true

  def tenant
    @tenant || Tenant.new(tenant_code)
  end
end
