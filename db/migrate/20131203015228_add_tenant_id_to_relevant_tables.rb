class AddTenantIdToRelevantTables < ActiveRecord::Migration
  def change
    add_column :films, :tenant_id, :integer
    add_column :machines, :tenant_id, :integer
    add_column :master_films, :tenant_id, :integer
    add_column :phase_snapshots, :tenant_id, :integer
    add_column :sales_orders, :tenant_id, :integer
    add_column :users, :tenant_id, :integer
    add_column :versions, :tenant_id, :integer
    add_index :films, :tenant_id
    add_index :machines, :tenant_id
    add_index :master_films, :tenant_id
    add_index :phase_snapshots, :tenant_id
    add_index :sales_orders, :tenant_id
    add_index :users, :tenant_id
    add_index :versions, :tenant_id
  end
end
