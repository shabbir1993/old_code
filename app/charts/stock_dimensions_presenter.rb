class StockDimensionsPresenter
  attr_reader :large_stock_films

  def initialize(tenant)
    @large_stock_films = tenant.widgets(Film).active.phase('stock').large(tenant.small_area_cutoff).not_reserved.includes(:master_film).includes(:dimensions)
  end

  def film_dimension_counts_by_formula
    all_film_dimensions = large_stock_films.count(:all, group: ['master_films.formula', 'dimensions.length', 'dimensions.width']).map do |k, v|
      k << v
    end
    all_film_dimensions.group_by(&:first)
  end
end
