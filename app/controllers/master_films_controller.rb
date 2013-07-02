class MasterFilmsController < ApplicationController
  
  def index
    @master_films = MasterFilm.all
  end

  def new
    @master_film = MasterFilm.new
  end

  def create
    @master_film = MasterFilm.new(params[:master_film])
    if @master_film.save
      redirect_to films_path('lamination'), notice: "Master film created."
    else
      render 'new'
    end
  end
end
