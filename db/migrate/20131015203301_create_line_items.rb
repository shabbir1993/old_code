class CreateLineItems < ActiveRecord::Migration
  def change
    create_table :line_items do |t|
      t.belongs_to :sales_order
      t.decimal :custom_width
      t.decimal :custom_length
      t.integer :quantity
      
      t.timestamps
    end
  end
end
