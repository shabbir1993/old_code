class FilmsController < ApplicationController
  def index
    @films = filtered_films.order_by(sort[0], sort[1]).page(params[:page])
    respond_to do |format|
      format.html
      format.csv { render csv: @films }
    end
  end

  def formula_totals
    @data = FilmFormulaTotals.new(filtered_films)
  end

  def dimensions_map
    @data = DimensionsMap.new(filtered_films)
  end

  def shelf_inventory
    @shelves = filtered_films.has_shelf.group_by(&:shelf).sort_by { |k,v| k }
  end

  def edit
    @film = tenant_films.find(params[:id])
    render layout: false
  end

  def update
    @film = tenant_films.find(params[:id])
    @film.update_and_move(params[:film], params[:film][:destination], current_user)
  end 

  def edit_multiple
    @films = tenant_films.find(params[:film_ids])
    render layout: false
  end

  def update_multiple
    @films = tenant_films.find(params[:film_ids])
    @films.each do |film|
      film.update_and_move(params[:film].reject { |k,v| v.blank? }, params[:film][:destination], current_user)
    end
  end

  def split
    @film = tenant_films.find(params[:id])
    @split = @film.split
  end

  def destroy
    @film = tenant_films.find(params[:id])
    @film.update_attributes(deleted: true)
  end

  def restore
    @film = tenant_films.find(params[:id])
    @film.update_attributes(deleted: false)
  end

  def unassign
    @film = tenant_films.find(params[:id])
    @film.unassign
  end

  private

  def tenant_films
    current_tenant.films
  end
  helper_method :tenant_films

  def filtered_films
    tenant_films.join_dimensions
                .phase(params[:tab], current_tenant)
                .filter(filtering_params)
  end
  helper_method :filtered_films

  def dimensions_searched?
    params[:width_greater_than].present? || params[:length_greater_than].present?
  end

  def sort
    params.fetch(:sort) do
      dimensions_searched? ? 'area_asc' : 'serial_desc'
    end.split('_')
  end
  helper_method :sort

  def filtering_params
    params.slice(:text_search, :formula_like, :width_greater_than, :length_greater_than, :serial_date_before, :serial_date_after)
  end
end
