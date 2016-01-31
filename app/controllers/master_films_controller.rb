class MasterFilmsController < ApplicationController
  def new
    @master_film = current_tenant.new_master_film
    render layout: false
  end

  def create
    @master_film = current_tenant.new_master_film(master_film_params)
    unless @master_film.save_and_create_child(current_user)
      render :display_modal_error_messages, locals: { object: @master_film }
    end
  end

  def index
    @master_films = filtered_master_films.page(params[:page])
    respond_to do |format|
      format.html
      format.csv { render csv: filtered_master_films }
    end
  end

  def dimensions_map
    @data = DimensionsMap.new(filtered_master_films)
  end

  def bvalue_series
    filtered_master_films_with_bvalue = filtered_master_films.where.not(b_value: nil)
    @series = BvalueSeries.new(filtered_master_films_with_bvalue)
  end

  def wep_series
    filtered_master_films_with_wep_values = filtered_master_films.where.not(wep_visible_on: nil, wep_ir_off: nil)
    @series = WepSeries.new(filtered_master_films_with_wep_values)
  end

  def edit
    @master_film = tenant_master_films.find(params[:id])
    render layout: false
  end

  def update
    @master_film = tenant_master_films.find(params[:id])
    unless @master_film.update_attributes(master_film_params)
      render :display_modal_error_messages, locals: { object: @master_film }
    end
  end 

  private

  def filtered_master_films
    @filtered_master_films ||= tenant_master_films.active.function(params[:function]).filter(filtering_params).by_serial
  end
  helper_method :filtered_master_films

  def tenant_master_films
    @tenant_master_films ||= current_tenant.master_films
  end

  def filtering_params
    params.slice(:text_search, :formula_like, :serial_date_before, :serial_date_after)
  end

  def master_film_params
    params.require(:master_film).permit(:serial, :effective_width, :effective_length, :formula, :mix_mass, :b_value, :temperature, :humidity, :film_code_top, :machine_id, :thinky_code, :chemist, :operator, :inspector, :note, :micrometer_left, :micrometer_right, :run_speed, :function, :defects, :wep_uv_on, :wep_visible_on, :wep_ir_on, :wep_uv_off, :wep_visible_off, :wep_ir_off).tap do |white_listed|
      white_listed[:defects] = params[:master_film][:defects] || {}
    end
  end
end
