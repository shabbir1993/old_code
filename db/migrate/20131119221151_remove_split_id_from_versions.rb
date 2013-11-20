class RemoveSplitIdFromVersions < ActiveRecord::Migration
  def change
    remove_column :versions, :split_id, :integer
  end
end
