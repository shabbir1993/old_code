class FilmsController < ApplicationController

  def index
    set_default_sort
    @films_presenter = FilmsPresenter.new(current_tenant, params)
    @films = @films_presenter.search_results
    respond_to do |format|
      format.html
      format.csv { send_data @films_presenter.to_csv }
    end
  end

  def edit
    @film = current_tenant.widget(Film, params[:id])
    render layout: false
  end

  def update
    @film = current_tenant.widget(Film, params[:id])
    @film.update_and_move(params[:film], params[:film][:destination], current_user)
  end 

  def edit_multiple
    @films = current_tenant.widget(Film, params[:film_ids])
    render layout: false
  end

  def update_multiple
    @films = current_tenant.widget(Film, params[:film_ids])
    @films.each do |film|
      film.update_and_move(params[:film].reject { |k,v| v.blank? }, params[:film][:destination], current_user)
    end
  end

  def split
    @film = current_tenant.widget(Film, params[:id])
    @split = @film.split
  end

  def destroy
    @film = current_tenant.widget(Film, params[:id])
    @film.update_attributes(deleted: true)
  end

  def restore
    @film = current_tenant.widget(Film, params[:id])
    @film.update_attributes(deleted: false)
  end

  def unassign
    @film = current_tenant.widget(Film, params[:id])
    @film.unassign
  end

  private

  def set_default_sort
    params[:sort] ||=  dimensions_searched? ? "area" : "serial"
    params[:direction] ||= dimensions_searched? ? "asc" : "desc"
  end

  def dimensions_searched?
    params[:min_width].present? || params[:min_length].present?
  end

  def films
    @decorated_films ||= Kaminari.paginate_array(decorate_collection(@films)).page(params[:page])
  end
  helper_method :films

  def film
    @decorated_film ||= decorate(@film)
  end
  helper_method :film

  def split_film
    @decorated_split_film ||= decorate(@split)
  end
  helper_method :split_film
end
