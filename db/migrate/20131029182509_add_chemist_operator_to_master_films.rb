class AddChemistOperatorToMasterFilms < ActiveRecord::Migration
  def change
    add_column :master_films, :operator, :string
    add_column :master_films, :chemist, :string
  end
end
