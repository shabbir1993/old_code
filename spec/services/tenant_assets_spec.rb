require_relative '../../app/services/tenant_assets.rb'

describe TenantAssets do
  let(:tenant) { instance_double("Tenant", code: "pe") }
  let(:model) { User }
  let(:tenant_assets) { TenantAssets.new(tenant, model) }
  
  it "builds a new tenant asset" do
    new_asset = instance_double("User")
    allow(model).to receive(:new).with(attr: "foo") { new_asset }
    expect(new_asset).to receive(:tenant_code=).with("pe")
    expect(tenant_assets.new(attr: "foo")).to eq(new_asset)
  end

  it "gets all assets" do
    assets = class_double("User")
    allow(model).to receive(:tenant).with("pe") { assets }
    expect(tenant_assets.all).to eq(assets)
  end

  it "finds an asset with an id" do
    assets = class_double("User")
    found_asset = instance_double("User")
    allow(model).to receive(:tenant).with("pe") { assets }
    allow(assets).to receive(:find).with(1) { found_asset }
    expect(tenant_assets.find_by_id(1)).to eq(found_asset)
  end
end
