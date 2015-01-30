class AddBValueToMasterFilms < ActiveRecord::Migration
  def change
    add_column :master_films, :b_value, :decimal
  end
end
