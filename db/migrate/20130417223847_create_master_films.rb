class CreateMasterFilms < ActiveRecord::Migration
  def change
    create_table :master_films do |t|
      t.string :date_code
      t.integer :number
      t.string :formula

      t.timestamps
    end
  end
end
