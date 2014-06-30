class DefectsTimeSeries

  def initialize(productions, master_films)
    @productions = productions
    @master_films = master_films
  end

  def data
    hash = {}
    defects.each do |d|
      hash[d] = defect_occurrences_by_date.map { |ary| [ary[0], ary[1][d].to_i] }
    end
    hash
  end

  def defects
    @master_films.defect_types
  end

  private

  def defect_occurrences_by_date
    @ary ||= @productions.map do |p|
      [p[:sort_date].to_datetime.to_i*1000, p[:relation].defect_occurrences]
    end
  end
end
