class ChangeTenantIdFieldsToNonNullable < ActiveRecord::Migration
  def change
    change_column :films, :tenant_id, :integer, null: false
    change_column :machines, :tenant_id, :integer, null: false
    change_column :master_films, :tenant_id, :integer, null: false
    change_column :phase_snapshots, :tenant_id, :integer, null: false
    change_column :sales_orders, :tenant_id, :integer, null: false
    change_column :users, :tenant_id, :integer, null: false
    change_column :versions, :tenant_id, :integer, null: false
  end
end
