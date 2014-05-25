class ShipmentsController < ApplicationController

  def index
    @shipments = Kaminari.paginate_array(grouped_shipments.reverse).page(params[:page])
  end

  def utilization_time_series
    @time_series = UtilizationTimeSeries.new(grouped_shipments)
  end

  def shipped_area_time_series
    @time_series = ShippedAreaTimeSeries.new(grouped_shipments)
  end

  private
  
  def grouped_shipments
    RelationGrouper.new(shipped_orders, 'ship_date', params[:start_date], params[:end_date]).send(params[:grouping])
  end

  def shipped_orders
    current_tenant.sales_orders.shipped
  end
end
