class YieldChart
  include ActionView::Helpers::NumberHelper

  attr_reader :master_films

  def initialize(tenant, inputs)
    @master_films = tenant.widgets(MasterFilm).search(inputs[:start_serial], inputs[:end_serial]).by_serial.reverse
  end

  def yield_points
    master_films.map do |mf| 
      { serial: mf.serial, :yield => number_with_precision(mf.yield, precision: 2) }
    end
  end

  def average
    master_films.map { |mf| mf.yield.to_f }.sum/master_films.count unless master_films.count == 0
  end
end
