class AddFilmCodeToMasterFilms < ActiveRecord::Migration
  def change
    add_column :master_films, :film_code, :string
  end
end
