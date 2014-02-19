class AddNeededIndices < ActiveRecord::Migration
  def change
    add_index :dimensions, :film_id
    add_index :film_movements, :film_id
    add_index :film_movements, :created_at
    add_index :films, :master_film_id
    add_index :films, :phase
    add_index :films, :deleted
    add_index :films, :sales_order_id
    add_index :films, :serial
    add_index :line_items, :sales_order_id
    add_index :master_films, :serial
    add_index :master_films, :machine_id
    add_index :sales_orders, :due_date
    add_index :sales_orders, :ship_date
    add_index :sales_orders, :cancelled
  end
end
