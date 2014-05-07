require 'active_support/concern'

module Tenancy
  extend ActiveSupport::Concern

  included do
    scope :tenant, ->(code) { where(tenant_code: code) }
  end

  def tenant
    @tenant || Tenant.new(tenant_code)
  end
end
