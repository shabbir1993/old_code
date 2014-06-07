class CalendarDay
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

  def progress_count
    progress = Hash.new
    progress[:reserved] = orders_due.not_shipped.films.phase('stock').total_order_fill_count
    progress[:wip] = orders_due.not_shipped.films.phase('wip').total_order_fill_count
    progress[:fg] = orders_due.not_shipped.films.phase('fg').total_order_fill_count
    progress[:shipped] = orders_due.shipped.films.total_order_fill_count
    progress[:total] = orders_due.line_items.total_quantity
    progress
  end

  private

  def self.all_dates(orders)
    orders.pluck(:due_date).uniq
  end
end
