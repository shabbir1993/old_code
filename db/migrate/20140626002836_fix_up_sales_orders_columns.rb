class FixUpSalesOrdersColumns < ActiveRecord::Migration
  def change
    remove_column :sales_orders, :cancelled
  end
end
