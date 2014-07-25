module Api
  class FilmsController < ApplicationController
    respond_to :json

    def show
      @film = tenant_films.find(params[:id])
    end

    def update
      @film = tenant_films.find(params[:id])
      @film.update_and_move(film_params, params[:destination], current_user)
    end

    def update_multiple
      @films = tenant_films.find(params[:film_ids])
      @films.each do |film|
        film.update_and_move(update_multiple_films_params, params[:destination], current_user)
      end
    end

    private

    def film_params
      params.require(:film).permit(:note, :shelf, :sales_order_id, :order_fill_count, dimensions_attributes: [:width, :length, :_destroy, :id])
    end

    def tenant_films
      current_tenant.films
    end
  end
end
