class AddSalesOrderIdToFilms < ActiveRecord::Migration
  def change
    add_column :films, :sales_order_id, :integer
  end
end
