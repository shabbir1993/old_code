class AddAreaAfterToVersions < ActiveRecord::Migration
  def change
    add_column :versions, :area_after, :decimal, default: 0, null: false
  end
end
