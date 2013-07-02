class AddChemistIdToMasterFilm < ActiveRecord::Migration
  def change
    add_column :master_films, :chemist_id, :integer
  end
end
