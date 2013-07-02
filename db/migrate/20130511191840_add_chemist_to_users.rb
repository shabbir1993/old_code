class AddChemistToUsers < ActiveRecord::Migration
  def change
    add_column :users, :chemist, :boolean, default: false
  end
end
