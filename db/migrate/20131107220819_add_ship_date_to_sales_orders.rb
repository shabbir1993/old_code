class AddShipDateToSalesOrders < ActiveRecord::Migration
  def change
    add_column :sales_orders, :ship_date, :date, default: nil
  end
end
