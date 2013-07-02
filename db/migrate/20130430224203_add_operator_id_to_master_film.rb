class AddOperatorIdToMasterFilm < ActiveRecord::Migration
  def change
    add_column :master_films, :operator_id, :integer
  end
end
