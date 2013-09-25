class FilmsController < ApplicationController
  def new
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
    safe_scopes = %w(lamination inspection wip fg test nc scrap large_stock
                     small_stock reserved_stock deleted)
    if safe_scopes.include? params[:scope]
      scoped_films = Film.send(params[:scope]).search_dimensions(params[:"min-width"], params[:"max-width"], params[:"min-length"], params[:"max-length"])
      @films = scoped_films.page(params[:page])
      @film_areas = scoped_films.map { |f| f.area ? f.area : 0 }
    end
  end

  def edit
    @film = Film.find(params[:id])
    render layout: false
  end

  def update
    @film = Film.find(params[:id])
    @film.update_attributes(params[:film])
  end 

  def edit_multiple
    @films = Film.find(params[:film_ids])
    @valid_destinations = @films.map(&:valid_destinations).reduce(:&)
    render layout: false
  end

  def update_multiple
    @films = Film.find(params[:film_ids])
    @valid_destinations = @films.map(&:valid_destinations).reduce(:&)
    if params[:film][:destination].present?
      @films.each do |film|
        film.update_attributes(params[:film])
      end
    end
  end

  def split
    session[:return_to] ||= request.referer
    @film = Film.find(params[:id])
    master_film = @film.master_film
    9.times { master_film.films.build }
    render layout: false
  end

  def create_split
    @film = Film.find(params[:id])
    @film.update_attributes(params[:film])
    @splits = @film.sibling_films.where("created_at > ?", 2.seconds.ago)
  end

  def restore
    @film = Film.unscoped.find(params[:id])
    @film.update_attributes(deleted: false)
  end
end
