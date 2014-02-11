class SalesOrderDecorator < ApplicationDecorator

  def self.applicable_classes
    [SalesOrder]
  end

  %w[ship_to release_date due_date note].each do |method_name|
    define_method(method_name) do
      return super() if super().present?
      "N/A"
    end
  end

  def count_fill_ratio
    "#{total_assigned_film_count}/#{total_quantity}"
  end

  def area_fill_ratio
    "#{number_with_precision(total_assigned_area, precision: 2)}/#{number_with_precision(total_custom_area, precision: 2)}"
  end

  def utilization
    number_to_percentage(super, precision: 2)
  end

  def destination
    if destroyed?
      "Deleted"
    elsif ship_date.present?
      "Shipped"
    else
      "Returned"
    end
  end
end
