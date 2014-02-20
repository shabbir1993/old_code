class AddAreaToFilms < ActiveRecord::Migration
  def up
    add_column :films, :area, :decimal, null: false, default: 0
    add_index :films, :area

    Film.unscoped.each do |f|
      f.area = f.dimensions.first.area unless f.dimensions.empty?
      f.save!
    end
  end

  def down
    remove_column :films, :area
  end
end
