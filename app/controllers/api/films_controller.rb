module Api
  class FilmsController < ApplicationController
    respond_to :json

    def show
      respond_with tenant_films.find(params[:id])
    end

    private

    def tenant_films
      current_tenant.films
    end
  end
end
