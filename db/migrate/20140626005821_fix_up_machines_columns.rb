class FixUpMachinesColumns < ActiveRecord::Migration
  def change
    change_column :machines, :yield_constant, :decimal, null: false
  end
end
