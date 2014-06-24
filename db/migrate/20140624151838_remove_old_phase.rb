class RemoveOldPhase < ActiveRecord::Migration
  def change
    remove_column :films, :old_phase
  end
end
