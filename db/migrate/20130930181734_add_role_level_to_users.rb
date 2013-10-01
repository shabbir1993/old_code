class AddRoleLevelToUsers < ActiveRecord::Migration
  def change
    add_column :users, :role_level, :integer, default: 0
  end
end
