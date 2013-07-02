class AddMachineIdToMasterFilm < ActiveRecord::Migration
  def change
    add_column :master_films, :machine_id, :integer
  end
end
