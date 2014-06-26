class FixUpLineItemsColumns < ActiveRecord::Migration
  def change
    change_column :line_items, :custom_width, :decimal, default: 0, null: false
    change_column :line_items, :custom_length, :decimal, default: 0, null: false
    change_column :line_items, :quantity, :integer, default: 1, null: false
    change_column :line_items, :product_type, :string, null: false
  end
end
