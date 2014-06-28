class ProducedAreaTimeSeries

  def initialize(productions, master_films)
    @productions = productions
    @master_films = master_films
  end

  def data
    hash = {}
    formulas.each do |t|
      hash[t] = @productions.map do |s|
        [s[:sort_date].to_datetime.to_i*1000, s[:relation].formula_like(t).total_effective_area.to_f]
      end
    end
    hash
  end

  def formulas
    @master_films.pluck(:formula).uniq
  end
end
