class AddNoteToMasterFilms < ActiveRecord::Migration
  def change
    add_column :master_films, :note, :text
  end
end
