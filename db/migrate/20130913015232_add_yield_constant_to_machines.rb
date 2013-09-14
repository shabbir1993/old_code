class AddYieldConstantToMachines < ActiveRecord::Migration
  def change
    add_column :machines, :yield_constant, :decimal
  end
end
