class AddPhaseToFilm < ActiveRecord::Migration
  def change
    add_column :films, :phase, :string
  end
end
