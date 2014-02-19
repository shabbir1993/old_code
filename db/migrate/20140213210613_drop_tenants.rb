class DropTenants < ActiveRecord::Migration
  def up
    drop_table :tenants if ActiveRecord::Base.connection.tables.include?("tenants")

    add_column :films, :tenant_code, :string
    add_index :films, :tenant_code
    add_column :master_films, :tenant_code, :string
    add_index :master_films, :tenant_code
    add_column :sales_orders, :tenant_code, :string
    add_index :sales_orders, :tenant_code
    add_column :users, :tenant_code, :string
    add_index :users, :tenant_code
    add_column :phase_snapshots, :tenant_code, :string
    add_index :phase_snapshots, :tenant_code
    add_column :film_movements, :tenant_code, :string
    add_index :film_movements, :tenant_code
    add_column :machines, :tenant_code, :string
    add_index :machines, :tenant_code

    Film.unscoped.where(tenant_id: 1).update_all(tenant_code: "pi")
    Film.unscoped.where(tenant_id: 2).update_all(tenant_code: "pe")
    MasterFilm.unscoped.where(tenant_id: 1).update_all(tenant_code: "pi")
    MasterFilm.unscoped.where(tenant_id: 2).update_all(tenant_code: "pe")
    SalesOrder.unscoped.where(tenant_id: 1).update_all(tenant_code: "pi")
    SalesOrder.unscoped.where(tenant_id: 2).update_all(tenant_code: "pe")
    User.unscoped.where(tenant_id: 1).update_all(tenant_code: "pi")
    User.unscoped.where(tenant_id: 2).update_all(tenant_code: "pe")
    FilmMovement.unscoped.where(tenant_id: 1).update_all(tenant_code: "pi")
    FilmMovement.unscoped.where(tenant_id: 2).update_all(tenant_code: "pe")
    Machine.unscoped.where(tenant_id: 1).update_all(tenant_code: "pi")
    Machine.unscoped.where(tenant_id: 2).update_all(tenant_code: "pe")

    change_column :films, :tenant_code, :string, :null => false
    change_column :master_films, :tenant_code, :string, :null => false
    change_column :sales_orders, :tenant_code, :string, :null => false
    change_column :users, :tenant_code, :string, :null => false
    change_column :phase_snapshots, :tenant_code, :string, :null => false
    change_column :film_movements, :tenant_code, :string, :null => false
    change_column :machines, :tenant_code, :string, :null => false


    change_column :films, :tenant_id, :integer, null: true
    change_column :master_films, :tenant_id, :integer, null: true
    change_column :sales_orders, :tenant_id, :integer, null: true
    change_column :users, :tenant_id, :integer, null: true
    change_column :phase_snapshots, :tenant_id, :integer, null: true
    change_column :film_movements, :tenant_id, :integer, null: true
    change_column :machines, :tenant_id, :integer, null: true
  end

  def down
    remove_column :films, :tenant_code
    remove_column :master_films, :tenant_code
    remove_column :sales_orders, :tenant_code
    remove_column :users, :tenant_code
    remove_column :phase_snapshots, :tenant_code
    remove_column :film_movements, :tenant_code
    remove_column :machines, :tenant_code
  end
end
