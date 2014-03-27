class LeadTimeChart
  include ActionView::Helpers::NumberHelper

  def initialize(tenant, inputs)
    @shipped_sales_orders = tenant.widgets(SalesOrder).shipped.ship_date_range(inputs[:start_date], inputs[:end_date]).has_release_date.has_due_date
  end

  def cycle_time_points
    @shipped_sales_orders.by_code.reverse.map do |so| 
      { code: so.code, cycle_days: so.cycle_days, ship_date: so.ship_date }
    end
  end

  def average
    if @shipped_sales_orders.count > 0
      avg = @shipped_sales_orders.map { |sso| sso.cycle_days }.sum/@shipped_sales_orders.count.to_f
      number_with_precision(avg, precision: 2)
    end
  end

  def on_time_total
    @shipped_sales_orders.where('due_date >= ship_date').count
  end

  def late_total
    @shipped_sales_orders.where('due_date < ship_date').count
  end

  def count_grouped_by_cycle_time
    array = @shipped_sales_orders.group_by{ |o| o.cycle_days}.sort.map do |k,v|
      [k, v.count]
    end
    Hash[array]
  end
end
