class ShelfInventoryChart
  attr_reader :large_stock_films

  def initialize(tenant)
    @large_stock_films = tenant.widgets(Film).active.phase('stock').large(tenant.small_area_cutoff).not_reserved
  end

  def by_shelf
    large_stock_films.where("shelf <> ''").order("shelf ASC").group_by(&:shelf)
  end
end
