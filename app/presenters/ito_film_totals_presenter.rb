class ItoFilmTotalsPresenter
  attr_reader :films

  def initialize(films)
    @films = films
  end

  def count_and_area_by_ito
    all_ito_types.map do |type|
      {
        ito: type.present? ? type : "None",
        count: films.where("master_films.film_code = ?", type).count,
        area: films.where("master_films.film_code = ?", type).sum(:area)
      }
    end
  end

  private
  
  def all_ito_types
    films.pluck("master_films.film_code").uniq
  end
end
