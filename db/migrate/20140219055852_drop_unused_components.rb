class DropUnusedComponents < ActiveRecord::Migration
  def up
    drop_table :defects
    remove_column :film_movements, :tenant_id
    remove_column :films, :tenant_id
    remove_column :films, :line_item_id
    remove_column :line_items, :created_at
    remove_column :line_items, :updated_at
    remove_column :machines, :tenant_id
    remove_column :machines, :created_at
    remove_column :machines, :updated_at
    remove_column :master_films, :defects_sum
    remove_column :master_films, :tenant_id
    remove_column :sales_orders, :tenant_id
    remove_column :users, :tenant_id
  end

  def down
    raise NonReversableMigration
  end
end
