class AddCompletedToJobDates < ActiveRecord::Migration
  def change
    add_column :job_dates, :completed, :boolean, null: false, default: false
  end
end
