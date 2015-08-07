class AddFunctionToMasterFilms < ActiveRecord::Migration
  def up
    add_column :master_films, :function, :integer, default: 0, null: false
  end

  def down
    remove_column :master_films, :function, :integer, default: 0, null: false
  end
end
