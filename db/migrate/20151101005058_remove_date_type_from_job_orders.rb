class RemoveDateTypeFromJobOrders < ActiveRecord::Migration
  def change
    remove_column :job_dates, :date_type
  end
end
