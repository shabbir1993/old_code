class AddSerialDateToMasterFilms < ActiveRecord::Migration
  def up
    add_column :master_films, :serial_date, :date, null: false, default: Date.current
    MasterFilm.all.each do |mf| 
      mf.update_columns(serial_date: mf.laminated_at)
    end
  end

  def down
    remove_column :master_films, serial_date
  end
end
