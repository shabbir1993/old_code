class AddInspectorToMasterFilms < ActiveRecord::Migration
  def change
    add_column :master_films, :inspector, :string
  end
end
