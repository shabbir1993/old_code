class HistoryController < ApplicationController
  def all_movements
    @film_movements = film_movements.page(params[:page])
  end

  def fg_film_movements
    fg_film_movements = film_movements.to_fg
    @fg_film_movements = fg_film_movements.page(params[:page])
    respond_to do |format|
      format.html
      format.csv { render csv: fg_film_movements }
    end
  end

  def scrap_film_movements
    @scrap_film_movements = film_movements.to_scrap.page(params[:page])
  end

  private

  def film_movements 
    tenant_film_movements.all
      .exclude_deleted_films
      .text_search(params[:query])
      .search_date_range(params[:start_date], params[:end_date])
      .sort_by_created_at
  end

  def tenant_film_movements
    @tenant_film_movements ||= TenantAssets.new(current_tenant, FilmMovement)
  end
end
