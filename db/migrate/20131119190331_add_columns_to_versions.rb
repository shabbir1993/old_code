class AddColumnsToVersions < ActiveRecord::Migration
  def change
    add_column :versions, :area_change, :decimal, array: true
    add_column :versions, :split_id, :integer
  end
end
