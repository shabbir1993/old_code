class MasterFilmsController < ApplicationController
  def new
    @master_film = MasterFilm.new
    render layout: false
  end

  def create
    @master_film = MasterFilm.new(params[:master_film])
    if @master_film.save
      @film = @master_film.films.create(phase: "lamination")
    end
  end

  def index
    master_films = MasterFilm.active.search(params[:start_serial], params[:end_serial]).by_serial.includes(:machine)
    @master_films = master_films.page(params[:page])
    respond_to do |format|
      format.html
      format.csv { send_data master_films.limit(100).to_csv }
    end
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
