class AddColumnsToLineItem < ActiveRecord::Migration
  def change
    add_column :line_items, :wire_length, :string
    add_column :line_items, :busbar_type, :string
    add_column :line_items, :note, :text
  end
end
