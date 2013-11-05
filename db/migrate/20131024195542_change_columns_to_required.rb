class ChangeColumnsToRequired < ActiveRecord::Migration
  def change
    change_column :defects, :defect_type, :string, :null => false
    change_column :defects, :count, :integer, :null => false
    change_column :defects, :master_film_id, :integer, :null => false
    change_column :films, :master_film_id, :integer, :null => false
    change_column :films, :phase, :string, :null => false
    change_column :line_items, :sales_order_id, :integer, :null => false
    change_column :machines, :code, :string, :null => false
    change_column :master_films, :serial, :string, :null => false
    change_column :phase_snapshots, :phase, :string, :null => false
    change_column :phase_snapshots, :count, :integer, :null => false
    change_column :phase_snapshots, :total_area, :decimal, :null => false
    change_column :sales_orders, :code, :string, :null => false
    change_column :users, :username, :string
  end
end
