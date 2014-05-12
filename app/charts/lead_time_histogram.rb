class LeadTimeHistogram

  def initialize(orders)
    @orders = orders.shipped.has_release_date
  end

  def lead_day_range
    if lead_days_ary.any?
      (0..max_lead_days).to_a
    else
      []
    end
  end

  def data
    lead_day_range.map { |d| lead_days_ary.grep(d).count }
  end

  private

  def lead_days_ary
    @orders.map { |o| o.lead_days }
  end

  def max_lead_days
    lead_days_ary.max
  end
end
