class AddStatusToMasterFilms < ActiveRecord::Migration
  def up
    add_column :master_films, :status, :integer, default: 0, null: false
    MasterFilm.all.each do |mf|
      if (mf.effective_width.nil? && mf.effective_length.nil?) && (mf.serial[0] == 'F' || mf.serial[0] == 'G')
        mf.update_columns(status: 0)
      elsif mf.films.pluck(:phase).uniq == ['test']
        mf.update_columns(status: 2)
      else
        mf.update_columns(status: 1)
      end
    end
  end

  def down
    remove_column :master_films, :status
  end
end
