class AddEngineeringFieldsToMasterFilms < ActiveRecord::Migration
  def change
    add_column :master_films, :micrometer_left, :decimal
    add_column :master_films, :micrometer_right, :decimal
    add_column :master_films, :run_speed, :decimal
  end
end
