class PlanningDay
  extend SimpleCalendar
  attr_accessor :starts_at

  def initialize(starts_at, orders)
    @starts_at = starts_at
    @orders = orders
  end

  def self.all
  end
end
