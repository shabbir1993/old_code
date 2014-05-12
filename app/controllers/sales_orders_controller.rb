class SalesOrdersController < ApplicationController
  before_filter :check_admin, only: [:destroy, :return]

  def index
    @sales_orders = filtered_orders.page(params[:page])
    @total_orders = filtered_orders.count(:all)
    @total_area = filtered_orders.line_items.total_area
    respond_to do |format|
      format.html
      format.csv do 
        render csv: filtered_orders if params[:data] == "orders"
        render csv: filtered_orders.line_items if params[:data] == "line_items"
      end
    end
  end

  def lead_time_histogram
    @histogram = LeadTimeHistogram.new(filtered_orders)
  end
  
  def new
    @sales_order = current_tenant.new_sales_order
    render layout: false
  end

  def create
    @sales_order = current_tenant.new_sales_order(params[:sales_order])
    render :display_error_messages unless @sales_order.save
  end

  def edit 
    @sales_order = sales_orders.find(params[:id])
    render layout: false
  end

  def update
    @sales_order = sales_orders.find(params[:id])
    render :display_error_messages unless @sales_order.update_attributes(params[:sales_order])
  end

  def move
    @sales_order = sales_orders.find(params[:id])
    @sales_order.status = params[:destination]
    @sales_order.save!
  end

  def destroy
    @sales_order = sales_orders.find(params[:id])
    @sales_order.destroy!
  end

  def edit_ship_date
    @sales_order = sales_orders.find(params[:id])
    render layout: false
  end

  def update_ship_date
    @sales_order = sales_orders.find(params[:id])
    @sales_order.update_attributes(params[:sales_order])
    @sales_order.status = "shipped"
    @sales_order.save!
  end

  private
  def filtered_orders
    sales_orders.send(params[:status]).filter(filtering_params).by_code
  end

  def sales_orders
    current_tenant.sales_orders
  end

  def filtering_params
    params.slice(:text_search, :ship_date_before, :ship_date_after)
  end
end
