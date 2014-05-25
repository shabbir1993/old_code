class UtilizationTimeSeries

  def initialize(shipments)
    @shipments = shipments
  end

  def data
    @shipments.map do |s|
      [s[:sort_date].to_datetime.to_i*1000, s[:relation].avg_utilization.to_f]
    end
  end

  def overall_average
    return 0 if @shipments.empty?
    @shipments.map { |s| s[:relation].avg_utilization.to_f }.reduce(:+)/@shipments.count
  end
end
