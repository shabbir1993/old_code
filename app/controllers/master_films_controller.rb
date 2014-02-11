class MasterFilmsController < ApplicationController
  def new
    @master_film = current_tenant.new_widget(MasterFilm)
    render layout: false
  end

  def create
    @master_film = current_tenant.new_widget(MasterFilm, params[:master_film])
    @master_film.save_and_create_child
  end

  def index
    @master_films = MasterFilmsPresenter.new(current_tenant, params).present
    respond_to do |format|
      format.html
      format.csv { send_data @master_films.to_csv }
    end
  end

  def edit
    @master_film = current_tenant.widget(MasterFilm, params[:id])
    render layout: false
  end

  def update
    @master_film = current_tenant.widget(MasterFilm, params[:id])
    @master_film.update_attributes(params[:master_film].reverse_merge(defects: {}))
  end 

  private

  def master_films
    @decorated_master_films ||= Kaminari.paginate_array(decorate_collection(@master_films)).page(params[:page])
  end
  helper_method :master_films

  def master_film
    @decorated_master_film ||= decorate(@master_film)
  end
  helper_method :master_film
end
