class SolderSeries
  def initialize(records)
    @films = records
  end

  def data
    series = {}
    series[:height1] =[]
    series[:height2] = []
    ordered_films.includes(:solder_measurements).map.with_index do |film, i|
      film.solder_measurements.map do |sm|
        series[:height1] << [i, sm.height1.to_f]
        series[:height2] << [i, sm.height2.to_f]
      end
    end
    series
  end

  def categories
    ordered_films.map do |film|
      film.serial
    end
  end

  def ordered_films
    @ordered_films ||= @films.reorder('films.serial ASC')
  end
end