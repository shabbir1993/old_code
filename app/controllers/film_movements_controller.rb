class FilmMovementsController < ApplicationController

  def index
    @film_movements = film_movements.page(params[:page])
    respond_to do |format|
      format.html
      format.csv { render csv: film_movements }
    end
  end

  def map
    map = FilmMovementsMap.new(film_movements)
    @categories = map.categories
    @map_data = map.data
  end

  private

  def film_movements 
    @movements ||= current_tenant.film_movements
      .exclude_deleted_films
      .filter(filtering_params)
      .sort_by_created_at
  end

  def filtering_params
    params.slice(:text_search, :from_phase, :to_phase, :created_at_before, :created_at_after)
  end
end
