class UtilizationChart
  include ActionView::Helpers::NumberHelper

  attr_reader :shipped_sales_orders

  def initialize(tenant, inputs)
    @shipped_sales_orders = tenant.widgets(SalesOrder).shipped.ship_date_range(inputs[:start_date], inputs[:end_date])
  end

  def averages_by_week
    shipped_sales_orders.group_by { |o| o.ship_date.beginning_of_week }.sort.map do |k,v| 
      { week_start: k, average_util:  number_with_precision(average_utilization(v), precision: 2) }
    end
  end

  def overall_average
    number_with_precision(average_utilization(shipped_sales_orders), precision: 2)
  end

  private

  def average_utilization(sales_orders)
    orders_with_utilization = sales_orders.reject { |so| so.utilization.nil? }
    orders_with_utilization.sum(&:utilization)/orders_with_utilization.count
  end
end
