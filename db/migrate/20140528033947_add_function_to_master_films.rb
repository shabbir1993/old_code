class AddFunctionToMasterFilms < ActiveRecord::Migration
  def up
    add_column :master_films, :function, :integer, default: 0, null: false
    MasterFilm.all.each do |mf|
      if mf.films.active.pluck(:phase).uniq == ['test']
        mf.update_columns(function: 1)
      elsif mf.in_house == false
        mf.update_columns(function: 2)
      end
    end

    MasterFilm.active.text_search("PE FILM").each do |mf|
      mf.update_columns(function: 2)
    end
  end

  def down
    remove_column :master_films, :function, :integer, default: 0, null: false
  end
end
