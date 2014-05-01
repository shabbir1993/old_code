class AddStatusToSalesOrders < ActiveRecord::Migration
  def up
    add_column :sales_orders, :status, :integer, default: 0, null: false
    SalesOrder.where(cancelled: true).update_all(status: 2) 
    SalesOrder.where('ship_date is not null and cancelled = false').update_all(status: 3) 
    SalesOrder.where(ship_date: nil, cancelled: false).update_all(status: 0) 
  end

  def down
    remove_column :sales_orders, :status
  end
end
