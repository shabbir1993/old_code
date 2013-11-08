class FilmsController < ApplicationController
  def index
    safe_scopes = %w(lamination inspection wip fg test nc scrap large_stock
                     small_stock reserved_stock deleted)
    if safe_scopes.include? params[:scope] || params[:scope].nil?
      films = Film.send(params[:scope]).text_search(params[:query]).search_dimensions(params[:"min-width"], params[:"max-width"], params[:"min-length"], params[:"max-length"])
      @films = films.page(params[:page])
    end
  end

  def edit
    @film = Film.find(params[:id])
    render layout: false
  end

  def update
    @film = Film.find(params[:id])
    @film.assign_attributes(params[:film])
    @film.save
  end 

  def edit_multiple
    @films = Film.find(params[:film_ids])
    render layout: false
  end

  def update_multiple
    @films = Film.find(params[:film_ids])
    @films.each do |film|
      film.update_attributes(params[:film].reject { |k,v| v.blank? })
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

  def unassign
    @film = Film.find(params[:id])
    @film.update_attributes(line_item_id: nil)
  end
end
