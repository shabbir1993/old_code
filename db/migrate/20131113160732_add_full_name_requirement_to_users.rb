class AddFullNameRequirementToUsers < ActiveRecord::Migration
  def change
    change_column :users, :full_name, :string, null: false
  end
end
