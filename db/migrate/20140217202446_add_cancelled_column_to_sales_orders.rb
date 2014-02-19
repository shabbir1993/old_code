class AddCancelledColumnToSalesOrders < ActiveRecord::Migration
  def change
    add_column :sales_orders, :cancelled, :boolean, default: false
  end
end
