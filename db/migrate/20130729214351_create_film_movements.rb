class CreateFilmMovements < ActiveRecord::Migration
  def change
    create_table :film_movements do |t|
      t.string :from
      t.string :to
      t.decimal :area
      t.integer :film_id
      t.integer :user_id

      t.timestamps
    end
  end
end
