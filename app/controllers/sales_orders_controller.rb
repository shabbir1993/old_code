class SalesOrdersController < ApplicationController
  before_filter :check_admin, only: [:destroy, :return]

  def index
    @presenter = SalesOrdersPresenter.new(current_tenant, params)
    @sales_orders = @presenter.present
  end
  
  def new
    @sales_order = current_tenant.new_widget(SalesOrder)
    render layout: false
  end

  def create
    @sales_order = current_tenant.new_widget(SalesOrder, params[:sales_order])
    @sales_order.save
  end

  def edit 
    @sales_order = current_tenant.widget(SalesOrder, params[:id])
    render layout: false
  end

  def update
    @sales_order = current_tenant.widget(SalesOrder, params[:id])
    @sales_order.update_attributes(params[:sales_order])
  end

  def destroy
    @sales_order = current_tenant.widget(SalesOrder, params[:id])
    @sales_order.destroy!
  end

  def edit_ship_date
    @sales_order = current_tenant.widget(SalesOrder, params[:id])
    render layout: false
  end

  def update_ship_date
    @sales_order = current_tenant.widget(SalesOrder, params[:id])
    @sales_order.update_attributes(params[:sales_order])
  end

  def return
    @sales_order = current_tenant.widget(SalesOrder, params[:id])
    @sales_order.update_attributes!(ship_date: nil, cancelled: false)
  end

  def cancel
    @sales_order = current_tenant.widget(SalesOrder, params[:id])
    @sales_order.cancel
  end

  private

  def sales_orders
    @sales_orders.page(params[:page])
  end
  helper_method :sales_orders

  def sales_order
    @sales_order
  end
  helper_method :sales_order

  def tenant_sales_orders
    @tenant_film_movements ||= TenantAssets.new(current_tenant, SalesOrder)
  end
end
