class CreateFilmMovements < ActiveRecord::Migration
  def up
    create_table :film_movements do |t|
      t.string :from_phase, null: false
      t.string :to_phase, null: false
      t.decimal :width
      t.decimal :length
      t.string :actor, null: false
      t.integer :film_id, null: false
      t.integer :tenant_id, null: false

      t.timestamps
    end
  end

  def down
    drop_table :film_movements
  end
end
