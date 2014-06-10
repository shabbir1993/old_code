class ShelfInventoryChart
  attr_reader :large_stock_films

  def initialize(tenant)
    @large_stock_films = tenant.films.active.phase('stock').large(tenant.small_area_cutoff).available
  end

  def by_shelf
    large_stock_films.where("shelf <> ''").order("shelf ASC").group_by(&:shelf)
  end
end
