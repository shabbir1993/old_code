class FixUpLineItemsColumns < ActiveRecord::Migration
  def change
    change_column :line_items, :custom_width, :decimal, null: false
    change_column :line_items, :custom_length, :decimal, null: false
    change_column :line_items, :quantity, :integer, null: false
    change_column :line_items, :product_type, :string, null: false
  end
end
