class AddInspectorToUsers < ActiveRecord::Migration
  def change
    add_column :users, :inspector, :boolean, null: false, default: false
  end
end
