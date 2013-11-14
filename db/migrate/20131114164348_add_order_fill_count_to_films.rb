class AddOrderFillCountToFilms < ActiveRecord::Migration
  def change
    add_column :films, :order_fill_count, :integer, default: 1, nil: false
  end
end
