module Api
  class FilmsController < ApiController

    def show
      @film = tenant_films.find(params[:id])
    end

    def update
      @film = tenant_films.find(params[:id])
      if @film.update_and_move(film_params, params[:destination], current_user)
        respond_with "success"
      else
        render json: @film.errors.full_messages.to_json, status: 500
      end
    end

    def update_multiple
      @films = tenant_films.find(params[:film_ids])
      @films.each do |film|
        film.update_and_move(update_multiple_films_params, params[:destination], current_user)
      end
    end

    def assignable_orders
      @in_progress_orders = current_tenant.sales_orders.in_progress
    end

    private

    def film_params
      params.permit(:note, :shelf, :sales_order_id, :order_fill_count, dimensions_attributes: [:width, :length, :_destroy, :id])
    end

    def update_multiple_films_params
      params.reject { |k,v| v.blank? }.permit(:shelf)
    end

    def tenant_films
      current_tenant.films
    end
  end
end
