class AddHazeToMasterFilms < ActiveRecord::Migration
  def change
    add_column :master_films, :haze, :decimal
  end
end
