class PlanningController < ApplicationController
  def calendar
    @planning_days = sales_orders.has_due_date
  end

  private

  def sales_orders
    current_tenant.sales_orders
  end
end
