class AddPriorityToJobOrders < ActiveRecord::Migration
  def change
    add_column :job_orders, :priority, :string, null: false, default: ""
  end
end
