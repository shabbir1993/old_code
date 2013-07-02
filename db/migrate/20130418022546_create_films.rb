class CreateFilms < ActiveRecord::Migration
  def change
    create_table :films do |t|
      t.integer :division

      t.timestamps
    end
  end
end
