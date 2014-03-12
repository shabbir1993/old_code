class YieldChart
  include ActionView::Helpers::NumberHelper

  attr_reader :master_films_with_yield

  def initialize(tenant, inputs)
    @master_films_with_yield = tenant.widgets(MasterFilm).active.in_house.serial_range(inputs[:start_serial], inputs[:end_serial]).by_serial.reverse.reject { |mf| mf.yield.nil? }
  end

  def averages_by_week
    master_films_with_yield.group_by { |mf| mf.laminated_at.beginning_of_week }.sort.map do |k,v| 
      { week_start: k, :average_yield => number_with_precision(average_yield(v), precision: 2) }
    end
  end

  def overall_average
    number_with_precision(average_yield(master_films_with_yield), precision: 2)
  end

  private

  def average_yield(master_films)
    master_films.sum(&:yield)/master_films.count
  end
end
