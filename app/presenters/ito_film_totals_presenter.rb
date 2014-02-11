class ItoFilmTotalsPresenter
  attr_reader :large_stock_films

  def initialize(tenant)
    @large_stock_films = tenant.widgets(Film).large_stock
  end

  def count_and_area_by_ito
    all_ito_types.map do |type|
      films_of_type = large_stock_films.where("master_films.film_code = ?", type)
      {
        ito: type.present? ? type : "None",
        count: films_of_type.count,
        area: films_of_type.map{ |f| f.area.to_f }.sum
      }
    end
  end

  private
  
  def all_ito_types
    large_stock_films.pluck("master_films.film_code").uniq
  end
end
