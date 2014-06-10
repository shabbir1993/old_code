class StockDimensionsPresenter
  attr_reader :large_stock_films

  def initialize(tenant)
    @large_stock_films = tenant.films.active.phase('stock').large(tenant.small_area_cutoff).available.join_dimensions
  end

  def film_dimension_counts_by_formula
    all_film_dimensions = large_stock_films.group(['master_films.formula', 'dimensions.length', 'dimensions.width']).count.map do |k, v|
      k << v
    end
    all_film_dimensions.group_by(&:first)
  end
end
