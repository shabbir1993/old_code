class SalesOrdersController < ApplicationController
  def index
    @sales_orders = SalesOrder.by_code.page(params[:page])
  end
  
  def new
    @sales_order = SalesOrder.new
    render layout: false
  end

  def create
    @sales_order = SalesOrder.create(params[:sales_order])
  end

  def edit 
    @sales_order = SalesOrder.find(params[:id])
    render layout: false
  end

  def update
    @sales_order = SalesOrder.find(params[:id])
    @sales_order.update_attributes(params[:sales_order])
  end

  def destroy
    @sales_order = SalesOrder.find(params[:id])
    @sales_order.destroy
    redirect_to sales_orders_path, notice: "Sales order #{@sales_order.code} deleted."
  end
end
