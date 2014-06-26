class MakeFilmMovementsWidthAndLengthNonNullable < ActiveRecord::Migration
  def change
    change_column :film_movements, :width, :decimal, default: 0, null: false
    change_column :film_movements, :length, :decimal, default: 0, null: false
  end
end
