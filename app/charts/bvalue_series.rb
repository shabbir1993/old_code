class BvalueSeries
  def initialize(records)
    @master_films = records
  end

  def data
    @master_films.reorder('master_films.serial ASC').map do |mf|
      [mf.serial, mf.b_value.to_f]
    end
  end
end
