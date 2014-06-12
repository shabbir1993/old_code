class FilmFormulaTotals

  def initialize(films)
    @films = films.join_master_films
  end

  def values
    count_and_area_by_value.map { |i| i[:value] }
  end

  def counts
    count_and_area_by_value.map { |i| i[:count] }
  end

  def areas
    count_and_area_by_value.map { |i| i[:area] }
  end

  private
  
  def unique_values
    @films.pluck('master_films.formula').uniq
  end

  def count_and_area_by_value
    unique_values.map do |value|
      films_with_value = @films.where("master_films.formula = ?", value)
      {
        value: value.present? ? value : "None",
        count: films_with_value.count,
        area: films_with_value.map{ |f| f.area }.sum.to_f
      }
    end.sort_by { |i| i[:area] }.reverse
  end
end
