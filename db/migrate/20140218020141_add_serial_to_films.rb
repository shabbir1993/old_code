class AddSerialToFilms < ActiveRecord::Migration
  def up
    add_column :films, :serial, :string

    Film.unscoped.each do |f|
      f.serial = "#{f.master_film.serial}-#{f.division}"
      f.save(validate: false)
    end

    change_column :films, :serial, :string, null: false
  end

  def down
    remove_column :films, :serial
  end
end
