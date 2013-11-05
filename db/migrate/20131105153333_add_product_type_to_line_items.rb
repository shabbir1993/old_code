class AddProductTypeToLineItems < ActiveRecord::Migration
  def change
    add_column :line_items, :product_type, :string
  end
end
