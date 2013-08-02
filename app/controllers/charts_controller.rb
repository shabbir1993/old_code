class ChartsController < ApplicationController
  def stock_film_types
    all_film_types = Film.large_stock.joins(:master_film).pluck("master_films.film_code").uniq

    @data = all_film_types.map do |type|
      {
        film_type: type || "None",
        count: Film.large_stock.joins(:master_film).where("master_films.film_code = ?", type).count,
        total_area: Film.large_stock.joins(:master_film).where("master_films.film_code = ?", type).sum("width * length / 144").to_i
      }
    end
  end
end
