class CreateAvionicsJobOrder < ActiveRecord::Migration
  def change
    create_table :avionics_job_orders do |t|
      t.string :serial, null: false, default: ""
      t.string :quantity, null: false, default: ""
      t.string :part_number, null: false, default: ""
      t.string :run_number, null: false, default: ""
      t.string :note, null: false, default: ""

      t.timestamps null: false
    end

    add_index :avionics_job_orders, :serial, unique: true
  end
end
