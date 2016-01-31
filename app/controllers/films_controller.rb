class FilmsController < ApplicationController
  require 'rqrcode'

  def index
    @films = filtered_films.order_by(sort[0], sort[1]).page(params[:page])
    respond_to do |format|
      format.html
      format.csv { render csv: filtered_films }
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
    session[:return_to] ||= request.referer
    @film = tenant_films.find(params[:id])
    render layout: false
  end

  def update
    @film = tenant_films.find(params[:id])
    unless @film.update_and_move(film_params, params[:destination], current_user)
      render :display_modal_error_messages, locals: { object: @film }
    end
  end 

  def edit_multiple
    @films = tenant_films.find(params[:film_ids])
    if params[:edit]
      render :edit_multiple, layout: false
    elsif params[:qrcodes]
      render :qr_codes, layout: false
    end
  end

  def update_multiple
    @films = tenant_films.find(params[:film_ids])
    @films.each do |film|
      film.update_and_move(update_multiple_films_params, params[:destination], current_user)
    end
  end

  def split
    @film = tenant_films.find(params[:id])
    @split = @film.split
  end

  def destroy
    @film = tenant_films.find(params[:id])
    @film.update_attributes(deleted: true)
    redirect_to session.delete(:return_to), notice: "Film #{@film.serial} deleted."
  end

  def restore
    @film = tenant_films.find(params[:id])
    @film.update_attributes(deleted: false)
  end

  private

  def tenant_films
    @tenant_films ||= current_tenant.films
  end
  helper_method :tenant_films

  def filtered_films
    @filtered_films ||= tenant_films.join_dimensions
                                    .phase(params[:phase], current_tenant)
                                    .filter(filtering_params)
  end
  helper_method :filtered_films

  def dimensions_searched?
    params[:width_greater_than].present? || params[:length_greater_than].present?
  end

  def sort
    params.fetch(:sort) do
      dimensions_searched? ? 'area-asc' : 'serial-desc'
    end.split('-')
  end
  helper_method :sort

  def filtering_params
    params.slice(:text_search, :formula_like, :width_greater_than, :length_greater_than, :serial_date_before, :serial_date_after)
  end

  def film_params
    params.require(:film).permit(:note, :shelf, :sales_order_id, :order_fill_count,
                                 dimensions_attributes: [:width, :length, :_destroy, :id],
                                 solder_measurements_attributes: [:height1, :height2, :_destroy, :id])
  end

  def update_multiple_films_params
    params.require(:film).reject { |k,v| v.blank? }.permit(:shelf, :sales_order_id)
  end
end
