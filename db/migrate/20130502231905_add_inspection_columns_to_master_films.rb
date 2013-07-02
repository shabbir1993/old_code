class AddInspectionColumnsToMasterFilms < ActiveRecord::Migration
  def change
    add_column :master_films, :effective_width, :decimal
    add_column :master_films, :effective_length, :decimal
  end
end
