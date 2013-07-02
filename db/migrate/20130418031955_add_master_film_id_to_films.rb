class AddMasterFilmIdToFilms < ActiveRecord::Migration
  def change
    add_column :films, :master_film_id, :integer
  end
end
