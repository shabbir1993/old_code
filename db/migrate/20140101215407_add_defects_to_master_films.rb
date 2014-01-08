class AddDefectsToMasterFilms < ActiveRecord::Migration
  def up
    add_column :master_films, :defects, :hstore, default: '', null: false
  end

  def down
    remove_column :master_films, :defects
  end
end
