class PlanningDay
  extend SimpleCalendar
  has_calendar

  attr_accessor :starts_at

  def initialize(starts_at, orders)
    @starts_at = starts_at
    @orders = orders
  end

  def self.all(orders)
    all_dates(orders).map do |d|
      self.new(d, orders)
    end
  end

  def orders_due
    @orders.due_date_equals(starts_at)
  end

  def progress_by_phase
    progress = Hash.new
    progress[:reserved] = assigned_count('stock')
    progress[:wip] = assigned_count('wip')
    progress[:fg] = assigned_count('fg')
    progress[:total] = orders_due.line_items.total_quantity
    progress
  end

  private

  def self.all_dates(orders)
    orders.pluck(:due_date).uniq
  end

  def assigned_count(phase)
    orders_due.films.phase(phase).total_order_fill_count
  end
end
