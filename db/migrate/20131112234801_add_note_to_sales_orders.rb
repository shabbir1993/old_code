class AddNoteToSalesOrders < ActiveRecord::Migration
  def change
    add_column :sales_orders, :note, :text
  end
end
