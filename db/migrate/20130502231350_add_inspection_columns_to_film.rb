class AddInspectionColumnsToFilm < ActiveRecord::Migration
  def change
    add_column :films, :reserved_for, :text
    add_column :films, :note, :text
  end
end
