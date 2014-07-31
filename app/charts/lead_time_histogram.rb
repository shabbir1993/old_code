class LeadTimeHistogram

  def initialize(orders)
    @orders = orders.shipped
  end

  def lead_day_range
    if lead_days_ary.any?
      (0..max_lead_days).to_a
    else
      []
    end
  end

  def data
    lead_day_range.map do |d|
      orders = lead_days_ary.select { |_,v| v == d }
      { 
        serials: orders.keys,
        count: orders.count
      }
    end
  end

  private

  def lead_days_ary
    @orders.map { |o| { o.code => o.lead_days } }
  end

  def max_lead_days
    lead_days_ary.values.max
  end
end
