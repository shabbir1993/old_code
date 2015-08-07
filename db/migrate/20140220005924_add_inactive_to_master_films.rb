class AddInactiveToMasterFilms < ActiveRecord::Migration
  def change
    add_column :master_films, :inactive, :boolean, default: false
    add_index :master_films, :inactive
  end
end
