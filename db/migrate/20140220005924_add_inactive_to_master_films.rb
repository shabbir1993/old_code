class AddInactiveToMasterFilms < ActiveRecord::Migration
  def change
    add_column :master_films, :inactive, :boolean, default: false
    add_index :master_films, :inactive

    MasterFilm.unscoped.update_all(inactive: true)
    MasterFilm.includes(:films).where(films: { deleted: false }).each do |mf|
      mf.inactive = false
      mf.save(validate: false)
    end
  end
end
