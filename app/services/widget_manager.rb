class WidgetManager
  def initialize(tenant, model)
    @tenant = tenant
    @model = model
  end

  def new_widget
    @model.new(tenant_code: @tenant.code)
  end

  def all_widgets
    @model.where(tenant_code: @tenant.code)
  end

  def find_widget(id)
    all_widgets.find(id)
  end
end
