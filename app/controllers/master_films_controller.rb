class MasterFilmsController < ApplicationController
  def new
    @master_film = current_tenant.new_master_film
    render layout: false
  end

  def create
    @master_film = current_tenant.new_master_film(params[:master_film])
    render :display_error_messages unless @master_film.save_and_create_child(current_user)
  end

  def index
    @master_films = filtered_master_films.page(params[:page])
    respond_to do |format|
      format.html
      format.csv { render csv: @master_films.limit(1000) }
    end
  end

  def edit
    @master_film = master_films.find(params[:id])
    render layout: false
  end

  def update
    @master_film = master_films.find(params[:id])
    render :display_error_messages unless @master_film.update_attributes(params[:master_film].reverse_merge(defects: {}))
  end 

  private

  def filtered_master_films
    master_films.active.filter(filtering_params).by_serial
  end

  def master_films
    current_tenant.master_films
  end

  def filtering_params
    params.slice(:text_search, :serial_date_before, :serial_date_after)
  end
end
