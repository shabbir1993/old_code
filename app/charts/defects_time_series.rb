class DefectsTimeSeries

  def initialize(productions, master_films)
    @productions = productions
    @master_films = master_films
  end

  def data
    hash = {}
    defects.each do |d|
      hash[d] = cumulative_defect_occurrences_by_date.map { |ary| [ary[0], ary[1][d].to_i] }
    end
    hash
  end

  def defects
    @defects ||= @master_films.defect_types
  end

  private

  def cumulative_defect_occurrences_by_date
    cum_defects = {}
    @ary ||= @productions.map do |p|
      cum_defects = sum_defects(cum_defects, p[:relation].defect_occurrences)
      [p[:sort_date].to_datetime.to_i*1000, cum_defects]
    end
  end

  def sum_defects(a, b)
    a.merge(b) { |k, oldval, newval| oldval + newval }
  end
end
