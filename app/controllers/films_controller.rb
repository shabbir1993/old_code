class FilmsController < ApplicationController

  def index
    set_default_sort
    @films_presenter = FilmsPresenter.new(current_tenant, params)
    @films = @films_presenter.present
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
    @film.master_film.set_inactive(true) if @film.master_film.no_active_films?
  end

  def restore
    @film = current_tenant.widget(Film, params[:id])
    @film.update_attributes(deleted: false)
    @film.master_film.set_inactive(false) if @film.master_film.inactive?
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
    @films.page(params[:page])
  end
  helper_method :films

  def film
    @film
  end
  helper_method :film

  def split_film
    @split
  end
  helper_method :split_film
end
