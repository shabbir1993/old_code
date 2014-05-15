class AddInHouseToMasterFilms < ActiveRecord::Migration
  def up
    add_column :master_films, :in_house, :boolean, default: true
    MasterFilm.where("length(serial) > 8").update_all(in_house: false)
    MasterFilm.where("length(serial) > 8").each do |mf|
      mf.update_columns(serial: mf.serial[1,8])
    end
  end

  def down
    remove_column :master_films, :in_house
  end
end
