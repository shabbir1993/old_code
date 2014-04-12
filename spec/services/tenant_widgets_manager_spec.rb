require_relative '../../app/services/tenant_widgets_manager.rb'

describe TenantWidgetsManager do
  let(:tenant) { double(code: "pe") }
  let(:model) { double }
  
  it "builds a new widget" do
    new_widget = double
    widget_manager = TenantWidgetsManager.new(tenant, model)
    expect(model).to receive(:new).with(tenant_code: "pe") { new_widget }
    expect(widget_manager.new_widget).to eq(new_widget)
  end

  it "gets all widgets" do
    widgets = double
    widget_manager = TenantWidgetsManager.new(tenant, model)
    expect(model).to receive(:where).with(tenant_code: "pe") { widgets }
    expect(widget_manager.all_widgets).to eq(widgets)
  end

  it "gets one widget" do
    widgets = double
    widget = double
    widget_manager = TenantWidgetsManager.new(tenant, model)
    expect(model).to receive(:where).with(tenant_code: "pe") { widgets }
    expect(widgets).to receive(:find).with(1) { widget }
    expect(widget_manager.find_widget(1)).to eq(widget)
  end
end
