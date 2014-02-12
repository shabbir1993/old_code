class UtilizationChart
  include ActionView::Helpers::NumberHelper

  attr_reader :shipped_sales_orders

  def initialize(tenant, inputs)
    @shipped_sales_orders = tenant.widgets(SalesOrder).shipped.ship_date_range(inputs[:start_date], inputs[:end_date])
  end

  def utilization_points
    shipped_sales_orders.by_code.reverse.map do |so| 
      { code: so.code, utilization:  number_with_precision(so.utilization, precision: 2) }
    end
  end

  def average
    shipped_sales_orders.map { |sso| sso.utilization }.sum/shipped_sales_orders.count unless shipped_sales_orders.count == 0
  end
end
