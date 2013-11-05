class AddDueDateToSalesOrders < ActiveRecord::Migration
  def change
    add_column :sales_orders, :due_date, :date
  end
end
