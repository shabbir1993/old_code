class AddLineItemIdToFilms < ActiveRecord::Migration
  def change
    add_column :films, :line_item_id, :integer
  end
end
