class AddOriginToMasterFilm < ActiveRecord::Migration
  def up
    add_column :master_films, :origin, :string, default: "in_house", null: false
    MasterFilm.where(in_house: false).update_all(origin: "pe")
    MasterFilm.tenant("pi").active.text_search("PE FILM").each do |mf|
      mf.update_columns(origin: "PE")
    end
  end

  def down
    remove_column :master_films, :origin
  end
end
