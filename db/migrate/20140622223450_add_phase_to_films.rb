class AddPhaseToFilms < ActiveRecord::Migration
  def up
    rename_column :films, :phase, :old_phase
    add_column :films, :phase, :integer, default: 0, null: false
    Film.where(old_phase: 'lamination').update_all(phase: 0)
    Film.where(old_phase: 'inspection').update_all(phase: 1)
    Film.where(old_phase: 'stock').where("sales_order_id IS NULL").update_all(phase: 2)
    Film.where(old_phase: 'stock').where("sales_order_id IS NOT NULL").update_all(phase: 3)
    Film.where(old_phase: 'wip').update_all(phase: 4)
    Film.where(old_phase: 'fg').update_all(phase: 5)
    Film.where(old_phase: 'nc').update_all(phase: 6)
    Film.where(old_phase: 'scrap').update_all(phase: 7)
  end

  def down
    remove_column :films, :phase
    rename_column :films, :old_phase, :phase
  end
end
