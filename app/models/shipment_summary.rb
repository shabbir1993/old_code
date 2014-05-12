class ShipmentSummary
  def initialize(tenant, start_date = nil, end_date = nil)
    @start_date = start_date
    @end_date = end_date
    @tenant = tenant
  end

  def by_day
    ary = orders.group_by { |o| o.ship_date }.map do |k,v|
      data = {
        date: k,
        order_count: v.count,
        film_pieces: line_items_for(v).product_type_equals('Film').total_quantity,
        glass_pieces: line_items_for(v).product_type_equals('Glass').total_quantity,
        total_pieces: line_items_for(v).total_quantity,
        film_area: line_items_for(v).product_type_equals('Film').total_area.round(2),
        glass_area: line_items_for(v).product_type_equals('Glass').total_area.round(2),
        total_area: line_items_for(v).total_area.round(2),
        avg_utilization: average_utilization(v).round(2),
        orders: v
      }
    end.sort_by{ |s| s[:date] }
  end

  private

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
