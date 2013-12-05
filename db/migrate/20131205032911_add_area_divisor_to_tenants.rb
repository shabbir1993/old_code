class AddAreaDivisorToTenants < ActiveRecord::Migration
  def change
    add_column :tenants, :area_divisor, :decimal, null: false, default: 144
  end
end
