class DropFilmMovementsTable < ActiveRecord::Migration
  def up
    drop_table :film_movements
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end
end
