class AddColumnsChangedToVersions < ActiveRecord::Migration
  def change
    add_column :versions, :columns_changed, :string, array: true
  end
end
