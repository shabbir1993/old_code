class RenameAvionicsToAmo < ActiveRecord::Migration
  def change
    rename_table :avionics_job_orders, :job_orders
    rename_table :avionics_job_dates, :job_dates
    rename_column :job_dates, :avionics_job_order_id, :job_order_id
  end
end
