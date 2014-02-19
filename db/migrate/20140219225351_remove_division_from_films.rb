class RemoveDivisionFromFilms < ActiveRecord::Migration
  def change
    remove_column :films, :division
  end
end
