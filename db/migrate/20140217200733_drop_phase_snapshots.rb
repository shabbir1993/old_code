class DropPhaseSnapshots < ActiveRecord::Migration
  def change
    drop_table :phase_snapshots
  end
end
