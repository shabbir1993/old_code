class CreateMachinesTable < ActiveRecord::Migration
  def change
    create_table :machines do |t|
      t.string :code

      t.timestamps
    end
  end
end
