class RemoveDimensionsFromFilms < ActiveRecord::Migration
  def change
    remove_column :films, :width
    remove_column :films, :length
  end
end
