class ShippedAreaTimeSeries

  def initialize(shipments)
    @shipments = shipments
  end

  def film_data
    @shipments.map do |s|
      [s[:sort_date].to_datetime.to_i*1000, s[:relation].line_items.product_type_equals('Film').total_area.to_f]
    end
  end

  def glass_data
    @shipments.map do |s|
      [s[:sort_date].to_datetime.to_i*1000, s[:relation].line_items.product_type_equals('Glass').total_area.to_f]
    end
  end
end
