class AddYieldToMasterFilms < ActiveRecord::Migration
  def up
    add_column :master_films, :yield, :decimal
    MasterFilm.all.each do |mf|
      if mf.yieldable?
        mf.update_columns(yield: (100*mf.tenant.yield_multiplier*(mf.effective_area/mf.mix_mass)/mf.machine.yield_constant))
      end
    end
  end

  def down
    remove_column :master_films, :yield
  end
end
