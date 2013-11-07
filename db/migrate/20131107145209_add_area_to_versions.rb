class AddAreaToVersions < ActiveRecord::Migration
  def change
    add_column :versions, :area, :decimal
  end
end
