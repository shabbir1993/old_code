require 'test_helper'

describe WidgetManager do
  before do
    @tenant = Class.new { define_method(:code) { "pe" } }.new
    @model = Minitest::Mock.new
  end
  
  it "builds a new widget" do
    new_widget = Object.new
    widget_manager = WidgetManager.new(@tenant, @model)
    @model.expect :new, new_widget, [tenant_code: @tenant.code]
    widget_manager.new_widget.must_equal new_widget
    @model.verify
  end

  it "gets all widgets" do
    all_widgets = Object.new
    widget_manager = WidgetManager.new(@tenant, @model)
    @model.expect :where, all_widgets, [tenant_code: @tenant.code]
    widget_manager.all_widgets.must_equal all_widgets
    @model.verify
  end

  it "gets one widget" do
    all_widgets = Minitest::Mock.new
    widget = Object.new
    widget_manager = WidgetManager.new(@tenant, @model)
    @model.expect :where, all_widgets, [tenant_code: @tenant.code]
    all_widgets.expect :find, widget, [1]
    widget_manager.find_widget(1).must_equal widget
    @model.verify
    all_widgets.verify
  end
end
