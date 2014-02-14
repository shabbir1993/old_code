class Machine < ActiveRecord::Base
  include Importable
  attr_accessible :code, :yield_constant
  validates :code, presence: true
  validates :yield_constant, presence: true

  def tenant
    @tenant || Tenant.new(tenant_code)
  end
end
