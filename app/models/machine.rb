class Machine < ActiveRecord::Base
  include Importable
  attr_accessible :code, :yield_constant
  validates :code, presence: true
  validates :yield_constant, presence: true

  belongs_to :tenant

  default_scope { where(tenant_id: Tenant.current_id) if Tenant.current_id }
end
