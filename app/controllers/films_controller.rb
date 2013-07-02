class FilmsController < ApplicationController
  def index
    safe_scopes = %w{ lamination inspection stock wip fg testing nc scrap }
    if safe_scopes.include? params[:scope]
      @films = Film.send(params[:scope])
    end
  end

  def edit
    @film = Film.find(params[:id])
  end

  def update
    @film = Film.find(params[:id])
    if @film.update_attributes(params[:film].reject{|k,v| k = :phase && v.blank?})
     redirect_to films_path(@film.phase)
    else
     render 'edit'
    end
  end 

  def edit_multiple
    @films = Film.find(params[:film_ids])
    @valid_destinations = @films.map { |film| film.valid_destinations }.reduce(:&)
  end

  def update_multiple
    @films = Film.find(params[:film_ids])
    @valid_destinations = @films.map { |film| film.valid_destinations }.reduce(:&)
    if params[:film][:phase].present?
      @films.each do |film|
        film.update_attributes(params[:film])
      end
      redirect_to films_path(params[:film][:phase])
    else
      render 'edit_multiple'
    end
  end

  def split
    @film = Film.find(params[:id])
    @film.master_film.films.build
  end
end
