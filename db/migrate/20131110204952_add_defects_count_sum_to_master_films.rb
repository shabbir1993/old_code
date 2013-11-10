class AddDefectsCountSumToMasterFilms < ActiveRecord::Migration
  def change
    add_column :master_films, :defects_sum, :integer, default: 0, null: false
  end
end
