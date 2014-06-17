class ShippedAreaTimeSeries

  def initialize(shipments)
    @shipments = shipments
  end

  def data
    hash = {}
    product_types.each do |t|
      hash[t] = @shipments.map do |s|
        [s[:sort_date].to_datetime.to_i*1000, s[:relation].line_items.product_type_equals(t).total_area.to_f]
      end
    end
    hash
  end

  def product_types
    LineItem.pluck(:product_type).uniq
  end
end
