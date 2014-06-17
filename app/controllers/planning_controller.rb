class PlanningController < ApplicationController
  def calendar
    @calendar_days = CalendarDay.all(sales_orders)
  end

  private

  def sales_orders
    current_tenant.sales_orders.not_cancelled
  end
end
