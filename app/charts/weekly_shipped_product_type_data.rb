class WeeklyShippedProductTypeData
  include ActionView::Helpers::NumberHelper

  def initialize(sales_orders)
    @sales_orders = sales_orders.shipped
  end

  def area_shipped_by_date
    @sales_orders.group_by{ |o| o.ship_date.beginning_of_week }.sort.map do |k,v|
      { 
        week_start: k, 
        shipped_film_area: line_items_for(v).product_type_equals("Film").total_area.round(2),
        shipped_glass_area: line_items_for(v).product_type_equals("Glass").total_area.round(2)
      }
    end
  end

  def total_film_area_shipped 
    @sales_orders.line_items.product_type_equals("Film").total_area.round(2)
  end
  
  def total_glass_area_shipped 
    @sales_orders.line_items.product_type_equals("Glass").total_area.round(2)
  end

  def total_area_shipped
    number_with_delimiter(total_film_area_shipped + total_glass_area_shipped, delimiter: ',')
  end

  private

  def line_items_for(sales_orders)
    LineItem.where(sales_order_id: sales_orders.collect(&:id))
  end
end
