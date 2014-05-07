class Machine < ActiveRecord::Base
  include Tenancy

  attr_accessible :code, :yield_constant, :tenant_code
  validates :code, presence: true
  validates :yield_constant, presence: true
end
