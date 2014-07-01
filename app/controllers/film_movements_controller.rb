class FilmMovementsController < ApplicationController
  before_filter :set_default_start_date

  def index
    @film_movements = film_movements.sort_by_created_at.page(params[:page])
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

  def inventory_totals
    @time_series = InventoryTotals.new(tenant_movements, current_tenant)
  end

  private

  def tenant_movements
    current_tenant.film_movements.exclude_deleted_films
  end

  def film_movements 
    tenant_movements.filter(filtering_params)
  end

  def filtering_params
    params.slice(:text_search, :from_phase, :to_phase, :created_at_before, :created_at_after)
  end

  def set_default_start_date
    params[:created_at_after] ||= Date.current
  end
end
