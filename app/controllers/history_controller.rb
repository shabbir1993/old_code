class HistoryController < ApplicationController
  def all_movements
    @film_movements = film_movements.page(params[:page])
  end

  def fg_film_movements
    fg_film_movements = film_movements.where("to_phase = 'fg'")
    @fg_film_movements = fg_film_movements.page(params[:page])
    respond_to do |format|
      format.html
      format.csv { send_data fg_film_movements.fg_film_movements_to_csv }
    end
  end

  def scrap_film_movements
    @scrap_film_movements = film_movements.where("to_phase = 'scrap'").page(params[:page])
  end

  private

  def film_movements 
    current_tenant.widgets(FilmMovement)
      .exclude_deleted_films
      .text_search(params[:query])
      .search_date_range(params[:start_date], params[:end_date])
      .sort_by_created_at
  end
end
