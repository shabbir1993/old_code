class YieldTimeSeries

  def initialize(productions)
    @productions = productions
  end

  def data
    @productions.map do |s|
      [s[:sort_date].to_datetime.to_i*1000, s[:relation].avg_yield.to_f]
    end
  end

  def overall_average
    return 0 if @productions.empty?
    @productions.map { |s| s[:relation].avg_yield }.reduce(:+)/@productions.count
  end
end
