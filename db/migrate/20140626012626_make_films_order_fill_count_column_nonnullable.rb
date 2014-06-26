class MakeFilmsOrderFillCountColumnNonnullable < ActiveRecord::Migration
  def change
    change_column :films, :order_fill_count, :integer, default: 1, null: false
  end
end
