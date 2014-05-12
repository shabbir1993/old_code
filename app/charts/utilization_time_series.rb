class UtilizationTimeSeries

  def initialize(shipments)
    @shipments = shipments
  end

  def data
    @shipments.map do |s|
      [s[:date].to_datetime.to_i*1000, s[:avg_utilization].to_f]
    end
  end

  def overall_average
    avg = @shipments.map { |s| s[:avg_utilization] }.reduce(:+)/@shipments.count
    avg.round(2)
  end
end
