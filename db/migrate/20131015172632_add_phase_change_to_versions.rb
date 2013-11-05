class AddPhaseChangeToVersions < ActiveRecord::Migration
  def change
    add_column :versions, :phase_change, :string, array: true
  end
end
