class PlanningController < ApplicationController
  def calendar
    @planning_days = PlanningDay.all
  end

  private

  def sales_orders
    current_tenant.sales_orders
  end
end
