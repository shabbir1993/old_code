class RemoveOrderFieldsFromFilms < ActiveRecord::Migration
  def change
    remove_column :films, :sales_order_code, :string
    remove_column :films, :reserved_for, :string
    remove_column :films, :customer, :string
    remove_column :films, :custom_width, :decimal
    remove_column :films, :custom_length, :decimal
  end
end
