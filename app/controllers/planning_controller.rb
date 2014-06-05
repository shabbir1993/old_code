class PlanningController < ApplicationController
  def calendar
    @planning_days = PlanningDay.all(sales_orders)
  end

  private

  def sales_orders
    current_tenant.sales_orders.has_due_date
  end
end
