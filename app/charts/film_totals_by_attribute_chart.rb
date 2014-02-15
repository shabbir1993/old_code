class FilmTotalsByAttributeChart
  attr_reader :films, :attribute

  def initialize(films, attribute)
    @films = films
    @attribute = attribute
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
    films.pluck("#{attribute}").uniq
  end

  def count_and_area_by_value
    unique_values.map do |value|
      films_with_value = films.where("#{attribute} = ?", value)
      {
        value: value.present? ? value : "None",
        count: films_with_value.count,
        area: films_with_value.map{ |f| f.area }.sum.to_f
      }
    end.sort_by { |i| i[:area] }.reverse
  end
end
