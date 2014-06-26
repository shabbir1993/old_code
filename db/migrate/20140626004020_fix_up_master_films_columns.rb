class FixUpMasterFilmsColumns < ActiveRecord::Migration
  def change
    remove_column :master_films, :in_house
    remove_column :master_films, :inactive
    change_column :master_films, :effective_width, :decimal, default: 0, null: false
    change_column :master_films, :effective_length, :decimal, default: 0, null: false
  end
end
