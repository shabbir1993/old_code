class AddThinkyCodeToMasterFilm < ActiveRecord::Migration
  def change
    add_column :master_films, :thinky_code, :string
  end
end
