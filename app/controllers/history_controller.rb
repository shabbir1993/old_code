class HistoryController < ApplicationController
  def film_movements
    @film_movements = FilmMovement.page(params[:page])
  end

  def fg_film_movements
    @fg_film_movements = FilmMovement.fg.page(params[:page])
  end

  def scrap_film_movements
    @scrap_film_movements = FilmMovement.scrap.page(params[:page])
  end

  def reserved_checkouts
    @reserved_checkouts = FilmMovement.checkout.reserved.page(params[:page])
  end
end
