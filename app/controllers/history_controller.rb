class HistoryController < ApplicationController
  before_action :set_default_date_range, only: :index

  def index
    @film_movements = film_movements.page(params[:page])
    @movement_map_data = MovementMapData.for(film_movements)
    @dimensions_map_data = DimensionsMapData.new(film_movements)
    respond_to do |format|
      format.html
      format.csv { render csv: film_movements }
    end
  end

  private

  def film_movements 
    @movements ||= tenant_film_movements.all
      .exclude_deleted_films
      .filter(filtering_params)
      .sort_by_created_at
  end

  def filtering_params
    params.slice(:text_search, :from_phase, :to_phase, :created_at_before, :created_at_after)
  end

  def tenant_film_movements
    @tenant_film_movements ||= TenantAssets.new(current_tenant, FilmMovement)
  end

  def set_default_date_range
    params[:created_at_after] ||= Date.current.to_s
    params[:created_at_before] ||= (Date.current + 1).to_s
  end
end
