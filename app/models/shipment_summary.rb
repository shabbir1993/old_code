class ShipmentSummary
  def initialize(tenant, start_date = nil, end_date = nil)
    @start_date = start_date
    @end_date = end_date
    @tenant = tenant
  end

  def by_day
    ary = orders.group_by { |o| o.ship_date }.map do |k,v|
      { date: k }.merge summary_hash(v)
    end.sort_by{ |s| s[:date] }
  end

  def by_week
    ary = orders.group_by { |o| o.ship_date.beginning_of_week }.map do |k,v|
      { date: k }.merge summary_hash(v)
    end.sort_by{ |s| s[:date] }
  end

  def by_month
    ary = orders.group_by { |o| o.ship_date.beginning_of_month }.map do |k,v|
      { date: k }.merge summary_hash(v)
    end.sort_by{ |s| s[:date] }
  end

  def by_quarter
    ary = orders.group_by { |o| o.ship_date.beginning_of_quarter }.map do |k,v|
      { date: k }.merge summary_hash(v)
    end.sort_by{ |s| s[:date] }
  end

  private

  def summary_hash(orders)
    {
      order_count: orders.count,
      film_pieces: line_items_for(orders).product_type_equals('Film').total_quantity,
      glass_pieces: line_items_for(orders).product_type_equals('Glass').total_quantity,
      total_pieces: line_items_for(orders).total_quantity,
      film_area: line_items_for(orders).product_type_equals('Film').total_area.round(2),
      glass_area: line_items_for(orders).product_type_equals('Glass').total_area.round(2),
      total_area: line_items_for(orders).total_area.round(2),
      avg_utilization: average_utilization(orders).round(2),
      orders: orders
    }
  end


  def orders
    @tenant.sales_orders.shipped.filter(ship_date_after: @start_date, ship_date_before: @end_date)
  end

  def average_utilization(orders)
    orders_with_util = orders.reject { |so| so.utilization.nil? }
    if orders_with_util.any?
      orders_with_util.sum(&:utilization)/orders_with_util.count
    else
      0
    end
  end

  def line_items_for(sales_orders)
    LineItem.where(sales_order_id: sales_orders.map(&:id))
  end
end
