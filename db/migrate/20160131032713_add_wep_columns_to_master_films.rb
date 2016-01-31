class AddWepColumnsToMasterFilms < ActiveRecord::Migration
  def change
    add_column :master_films, :wep_uv_on, :decimal
    add_column :master_films, :wep_visible_on, :decimal
    add_column :master_films, :wep_ir_on, :decimal
    add_column :master_films, :wep_uv_off, :decimal
    add_column :master_films, :wep_visible_off, :decimal
    add_column :master_films, :wep_ir_off, :decimal
  end
end