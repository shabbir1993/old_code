class SalesOrdersController < ApplicationController
  before_filter :check_admin, only: [:destroy, :return]

  def index
    @sales_orders = SalesOrdersPresenter.new(current_tenant, params).present
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
    @sales_order.update_attributes!(ship_date: nil)
  end

  private

  def sales_orders
    @decorated_sales_orders ||= Kaminari.paginate_array(decorate_collection(@sales_orders)).page(params[:page])
  end
  helper_method :sales_orders

  def sales_order
    @decorated_sales_order ||= decorate(@sales_order)
  end
  helper_method :sales_order
end
