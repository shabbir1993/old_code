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
    if shipped_sales_orders.count > 0
      avg = shipped_sales_orders.map { |sso| sso.utilization.to_f }.sum/shipped_sales_orders.count
      number_with_precision(avg, precision: 2)
    end
  end
end
