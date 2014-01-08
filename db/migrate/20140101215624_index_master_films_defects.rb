class IndexMasterFilmsDefects < ActiveRecord::Migration
  def up
    execute "CREATE INDEX master_films_defects ON master_films USING GIN(defects)"
  end

  def down
    execute "DROP INDEX master_films_defects"
  end
end
