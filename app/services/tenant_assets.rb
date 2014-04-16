class TenantAssets
  def initialize(tenant, model)
    @tenant = tenant
    @model = model
  end

  def new(attrs = {} )
    new_asset = @model.new(attrs)
    new_asset.tenant_code = @tenant.code
    new_asset
  end

  def all
    @model.tenant(@tenant.code)
  end

  def find_by_id(id)
    all.find(id)
  end
end
