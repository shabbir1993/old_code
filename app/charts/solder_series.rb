class SolderSeries
  def initialize(records)
    @films = records
  end

  def data
    @data ||= begin
      series = {}
      series[:height1] = []
      series[:height2] = []
      ordered_films.includes(:solder_measurements).map.with_index do |film, i|
        film.solder_measurements.map do |sm|
          series[:height1] << [i, sm.height1.to_f]
          series[:height2] << [i, sm.height2.to_f]
        end
      end
      series
    end
  end

  def heights
    @heights ||= data[:height1].map{ |i| i[1] } + data[:height2].map{ |i| i[1] }
  end

  def mean
    @mean ||= heights.compact.inject{ |sum, el| sum + el }.to_f / heights.size
  end

  def sigma
    @sigma ||= begin
      sum = heights.inject(0){|accum, i| accum +(i-mean)**2 }
      variance = sum/(heights.length - 1).to_f
      Math.sqrt(variance)
    end
  end

  def three_sigma
    @three_sigma ||= 3 * sigma
  end

  def cpk
    @cpk ||= (0.043 - mean) / three_sigma
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