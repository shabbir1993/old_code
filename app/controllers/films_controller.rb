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
    @film.update_attributes(params[:film])
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
    @film = Film.find(params[:id])
    render layout: false
  end

  def create_split
    @film = Film.find(params[:id])
    if @film.update_attributes(params[:film])
      @split = @film.master_film.films.create(params[:film][:split])
    end
  end

  def restore
    @film = Film.unscoped.find(params[:id])
    @film.update_attributes(deleted: false)
  end

  def unassign
    @film = Film.find(params[:id])
    @film.update_attributes(sales_order_id: nil)
  end
end
