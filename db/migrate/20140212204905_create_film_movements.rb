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

    PaperTrail::Version.unscoped.movements.each do |v|
      @movement = FilmMovement.new
      @movement.from_phase = v.phase_change[0] || "raw"
      @movement.to_phase = v.phase_change[1]
      @movement.width = v.after.width
      @movement.length = v.after.length
      @movement.actor = v.whodunnit
      @movement.film_id = v.item_id
      @movement.tenant_id = v.tenant_id
      @movement.created_at = v.created_at
      @movement.save!
    end
  end

  def down
    drop_table :film_movements
  end
end
