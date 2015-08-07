class CreateAvionicsJobDate < ActiveRecord::Migration
  def change
    create_table :avionics_job_dates do |t|
      t.belongs_to :avionics_job_order, null: false, index: true, foreign_key: true
      t.string :step, null: false
      t.string :date_type, null: false
      t.date :value, null: false, index: true

      t.timestamps
    end
  end
end
