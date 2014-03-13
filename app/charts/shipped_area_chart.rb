class ShippedAreaChart
  include ActionView::Helpers::NumberHelper

  attr_reader :sales_orders

  def initialize(tenant, inputs)
    @sales_orders = tenant.widgets(SalesOrder).shipped.ship_date_range(inputs[:start_date], inputs[:end_date])
  end

  def area_shipped_by_date
    sales_orders.group_by{ |o| o.ship_date.beginning_of_week }.sort.map do |k,v|
      { 
        week_start: k, 
        shipped_film_area: number_with_precision(total_custom_area_by_product_type(v, "Film"), precision: 2), 
        shipped_glass_area: number_with_precision(total_custom_area_by_product_type(v, "Glass")) 
      }
    end
  end

  def total_film_area_shipped 
    sales_orders.total_custom_area_by_product_type("Film").round(2)
  end
  
  def total_glass_area_shipped 
    sales_orders.total_custom_area_by_product_type("Glass").round(2)
  end

  private

  def total_custom_area_by_product_type(sales_orders, type)
    total_area = 0
    sales_orders.each do |so|
      so.line_items.each do |li|
        total_area += li.custom_area if li.product_type == type
      end
    end
    total_area
  end
end
