class AddMixMassToMasterFilms < ActiveRecord::Migration
  def change
    add_column :master_films, :mix_mass, :decimal
  end
end
