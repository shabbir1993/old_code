class AddIndexForStatuses < ActiveRecord::Migration
  def change
    add_index :films, :phase
    add_index :sales_orders, :status
    add_index :users, :username
    add_index :sales_orders, :release_date
    add_index :film_movements, :from_phase
    add_index :film_movements, :to_phase
  end
end
