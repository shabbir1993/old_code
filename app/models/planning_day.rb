class PlanningDay
  extend SimpleCalendar
  attr_accessor :starts_at, :orders

  def initialize(starts_at, orders)
    @starts_at = starts_at
    @orders = orders
  end

  def self.all
    SalesOrder.all
  end

  private

  def all_dates
    SalesOrder.pluck(:due_date)
  end
end
