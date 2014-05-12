class ShipmentsController < ApplicationController

  def index
    @shipments = Kaminari.paginate_array(grouped_shipments).page(params[:page])
  end

  def utilization_time_series
    @time_series = UtilizationTimeSeries.new(grouped_shipments)
  end

  def shipped_area_time_series
    @time_series = ShippedAreaTimeSeries.new(grouped_shipments)
  end

  private
  
  def grouped_shipments
    ShipmentSummary.new(current_tenant, params[:start_date], params[:end_date]).send(params[:group])
  end
end
