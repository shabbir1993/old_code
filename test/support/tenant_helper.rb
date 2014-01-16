def setup_tenant
  tenant = FactoryGirl.create(:tenant)
  Tenant.current_id = tenant.id
end
