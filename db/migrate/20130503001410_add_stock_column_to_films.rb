class AddStockColumnToFilms < ActiveRecord::Migration
  def change
    add_column :films, :shelf, :string
    add_column :films, :width, :decimal
    add_column :films, :length, :decimal
  end
end
