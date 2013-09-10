class HistoryController < ApplicationController
  def film_movements
    @film_movements = FilmMovement.page(params[:page])
  end

  def fg_film_movements
    @fg_film_movements = FilmMovement.fg.page(params[:page])
  end

  def master_films
    @master_films = MasterFilm.order('serial DESC').page(params[:page])
  end
end

