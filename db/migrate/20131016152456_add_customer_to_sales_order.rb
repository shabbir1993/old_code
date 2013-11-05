class AddCustomerToSalesOrder < ActiveRecord::Migration
  def change
    add_column :sales_orders, :customer, :string
  end
end
