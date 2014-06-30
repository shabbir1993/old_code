class LineItemProductTypeTotals
  def initialize(line_items)
    @items = line_items
  end

  def values
    count_and_area_by_value.map { |i| i[:value] }
  end

  def counts
    count_and_area_by_value.map { |i| i[:count] }
  end

  def areas
    count_and_area_by_value.map { |i| i[:area] }
  end

  private
  
  def unique_values
    @items.pluck(:product_type).uniq
  end

  def count_and_area_by_value
    unique_values.map do |value|
      items_with_value = @items.where(product_type: value)
      {
        value: value.present? ? value : "None",
        count: items_with_value.total_quantity,
        area: items_with_value.total_area.to_f
      }
    end.sort_by { |i| i[:area] }.reverse
  end
end
