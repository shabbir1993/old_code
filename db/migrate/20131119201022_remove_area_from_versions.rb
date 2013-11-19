class RemoveAreaFromVersions < ActiveRecord::Migration
  def change
    remove_column :versions, :area, :decimal
  end
end
