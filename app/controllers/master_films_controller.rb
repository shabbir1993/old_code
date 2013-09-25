class MasterFilmsController < ApplicationController
  def index
    @master_films = MasterFilm.by_serial.page(params[:page])
  end

  def edit
    @master_film = MasterFilm.find(params[:id])
    render layout: false
  end

  def update
    @master_film = MasterFilm.find(params[:id])
    @master_film.update_attributes(params[:master_film])
  end 
end
