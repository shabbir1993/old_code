class SalesOrdersController < ApplicationController
  before_filter :check_admin, only: [:destroy]

  def index
    @sales_orders = filtered_orders.order_by(sort[0], sort[1]).page(params[:page])
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

  def product_type_totals
    @data = LineItemProductTypeTotals.new(filtered_orders.line_items)
  end

  def assigned_formula_totals
    @data = FilmFormulaTotals.new(filtered_orders.films)
    render 'films/formula_totals'
  end
  
  def new
    @sales_order = current_tenant.new_sales_order
    render layout: false
  end

  def create
    @sales_order = current_tenant.new_sales_order(params[:sales_order])
    unless @sales_order.save
      render :display_modal_error_messages, locals: { object: @sales_order }
    end
  end

  def edit 
    session[:return_to] ||= request.referer
    @sales_order = sales_orders.find(params[:id])
    render layout: false
  end

  def update
    @sales_order = sales_orders.find(params[:id])
    unless @sales_order.update_attributes(params[:sales_order])
      render :display_modal_error_messages, locals: { object: @sales_order }
    end
  end

  def move
    @sales_order = sales_orders.find(params[:id])
    @sales_order.status = params[:destination]
    @sales_order.save!
  end

  def destroy
    @sales_order = sales_orders.find(params[:id])
    @sales_order.destroy!
    redirect_to session.delete(:return_to), notice: "Order #{@sales_order.code} deleted."
  end

  def edit_ship_date
    @sales_order = sales_orders.find(params[:id])
    render layout: false
  end

  def update_ship_date
    @sales_order = sales_orders.find(params[:id])
    if @sales_order.update_attributes(params[:sales_order])
      @sales_order.shipped!
    else
      render :display_modal_error_messages, locals: { object: @sales_order }
    end
  end

  private

  def filtered_orders
    sales_orders.status(params[:status]).filter(filtering_params)
  end
  helper_method :filtered_orders

  def sales_orders
    current_tenant.sales_orders
  end
  helper_method :sales_orders

  def sort
    params.fetch(:sort) do
      'code-desc'
    end.split('-')
  end
  helper_method :sort

  def filtering_params
    params.slice(:text_search, :code_like, :ship_date_before, :ship_date_after)
  end
end
