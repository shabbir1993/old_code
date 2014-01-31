class HistoryController < ApplicationController
  def film_movements
    @film_movements = film_versions.movements.page(params[:page])
  end

  def fg_film_movements
    fg_film_movements = film_versions.where("phase_change[2] = 'fg' AND phase_change[1] <> 'fg'")
    @fg_film_movements = fg_film_movements.page(params[:page])
    respond_to do |format|
      format.html
      format.csv { send_data fg_film_movements.fg_film_movements_to_csv }
    end
  end

  def scrap_film_movements
    @scrap_film_movements = film_versions.where("phase_change[2] = 'scrap' AND phase_change[1] <> 'scrap'").page(params[:page])
  end

  private

  def film_versions 
    PaperTrail::Version.exclude_deleted_films
      .search_date_range(params[:start_date], params[:end_date])
      .sort_by_created_at
  end
end
