class CreateSolderMeasurements < ActiveRecord::Migration
  def change
    create_table :solder_measurements do |t|
      t.decimal :height1, default: 0.0, null: false
      t.decimal :height2, default: 0.0, null: false

      t.belongs_to :film, null: false
    end
  end
end