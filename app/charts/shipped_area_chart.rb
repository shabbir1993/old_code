class ShippedAreaChart
  include ActionView::Helpers::NumberHelper

  attr_reader :sales_orders, :dates

  def initialize(tenant, inputs)
    @sales_orders = tenant.widgets(SalesOrder).shipped.ship_date_range(inputs[:start_serial], inputs[:end_serial])
    @dates = (inputs[:start_date].try(:to_date) || SalesOrder.minimum(:ship_date))..(inputs[:end_date].try(:to_date) || SalesOrder.maximum(:ship_date))
  end

  def film_area_shipped_by_date
    dates.map{ |d| [d, sales_orders.with_ship_date(d).total_custom_area_by_product_type("Film").round(2) ] }
  end

  def glass_area_shipped_by_date
    dates.map{ |d| [d, sales_orders.with_ship_date(d).total_custom_area_by_product_type("Glass").round(2) ] }
  end

  def total_film_area_shipped 
    sales_orders.total_custom_area_by_product_type("Film").round(2)
  end
  
  def total_glass_area_shipped 
    sales_orders.total_custom_area_by_product_type("Glass").round(2)
  end
end
