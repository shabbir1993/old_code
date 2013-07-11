class FilmsController < ApplicationController
  def new
    session[:return_to] = request.referer
    @master_film = MasterFilm.new
    render layout: false
  end

  def create
    @master_film = MasterFilm.new(params[:master_film])
    if @master_film.save
      @film = @master_film.films.create(destination: "lamination")
    end
  end

  def index
    safe_scopes = %w{ lamination inspection wip fg testing nc scrap large_stock small_stock }
    if safe_scopes.include? params[:scope]
      @films = Film.send(params[:scope]).joins(:master_film).order('master_films.serial DESC').page(params[:page])
      @all_scope = Film.send(params[:scope])
    end
  end

  def edit
    session[:return_to] = request.referer
    @film = Film.find(params[:id])
    render layout: false
  end

  def update
    @film = Film.find(params[:id])
    @film.update_attributes(params[:film])
  end 

  def edit_multiple
    session[:return_to] = request.referer
    @films = Film.find(params[:film_ids])
    @valid_destinations = @films.map { |film| film.valid_destinations }.reduce(:&)
    render layout: false
  end

  def update_multiple
    @films = Film.find(params[:film_ids])
    @valid_destinations = @films.map { |film| film.valid_destinations }.reduce(:&)
    if params[:film][:destination].present?
      @films.each do |film|
        film.update_attributes(params[:film])
      end
    end
  end

  def split
    session[:return_to] ||= request.referer
    @film = Film.find(params[:id])
    @film.split(9)
    render layout: false
  end

  def create_split
    @film = Film.find(params[:id])
    @film.update_attributes(params[:film])
  end
end
