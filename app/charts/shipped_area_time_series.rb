class ShippedAreaTimeSeries

  def initialize(shipments)
    @shipments = shipments
  end

  def film_data
    @shipments.map do |s|
      [s[:date].to_datetime.to_i*1000, s[:film_area].to_f]
    end
  end

  def glass_data
    @shipments.map do |s|
      [s[:date].to_datetime.to_i*1000, s[:glass_area].to_f]
    end
  end
end
