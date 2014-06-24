class MakeDueDateReleaseDateNonNullable < ActiveRecord::Migration
  def change
    change_column :sales_orders, :release_date, :date, null: false
    change_column :sales_orders, :due_date, :date, null: false
  end
end
