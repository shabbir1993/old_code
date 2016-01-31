class RemoveItoBottomFromMasterFilms < ActiveRecord::Migration
  def change
    remove_column :master_films, :film_code_bottom, :string
  end
end