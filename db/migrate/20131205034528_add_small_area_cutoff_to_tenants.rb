class AddSmallAreaCutoffToTenants < ActiveRecord::Migration
  def change
    add_column :tenants, :small_area_cutoff, :decimal, null: false, default: 16
  end
end
