class AddDeletedToFilms < ActiveRecord::Migration
  def change
    add_column :films, :deleted, :boolean, default: false
  end
end
