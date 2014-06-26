class MakeUserColumnsNonNullable < ActiveRecord::Migration
  def change
    change_column :users, :role_level, :integer, default: 0, null: false
    change_column :users, :password_digest, :string, null: false
  end
end
