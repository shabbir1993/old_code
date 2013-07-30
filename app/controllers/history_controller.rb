class HistoryController < ApplicationController
  def film_movements
    @film_movements = FilmMovement.all
  end

  def fg_film_movements
    @fg_film_movements = FilmMovement.fg
  end
end

