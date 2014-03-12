class ChartsController < ApplicationController
  def stock_film_type_totals
    @chart = FilmTotalsByAttributeChart.new(large_stock_films, "master_films.film_code")
  end

  def stock_formula_totals
    @chart = FilmTotalsByAttributeChart.new(large_stock_films, "master_films.formula")
  end

  def stock_dimensions
    @data = StockDimensionsPresenter.new(current_tenant).film_dimension_counts_by_formula
  end

  def stock_snapshots
    presenter = StockSnapshotsPresenter.new(current_tenant)
    @stock_data = presenter.for_phase("large_stock")
    @reserved_stock_data = presenter.for_phase("reserved_stock")
  end

  def movement_summary
    @film_movement_totals_hash = MovementSummaryPresenter.new(current_tenant, params).film_movement_totals_hash
  end

  def shelf_inventory
    @films_group_shelf = ShelfInventoryChart.new(current_tenant).by_shelf
  end

  def utilization
    chart = UtilizationChart.new(current_tenant, params)
    @data = chart.averages_by_week
    @overall_average = chart.overall_average
  end

  def yield
    chart = YieldChart.new(current_tenant, params)
    @data = chart.averages_by_week
    @overall_average = chart.overall_average
  end

  def area_shipped
    chart = ShippedAreaChart.new(current_tenant, params)
    @chart = chart
    @total_film_area_shipped = chart.total_film_area_shipped
    @total_glass_area_shipped = chart.total_glass_area_shipped
  end

  def cycle_time
    chart = CycleTimeChart.new(current_tenant, params)
    @data = chart.cycle_time_points
    @average = chart.average
    @on_time_total = chart.on_time_total
    @late_total = chart.late_total
  end

  private

  def large_stock_films
    current_tenant.widgets(Film).active.phase('stock').large(current_tenant.small_area_cutoff).not_reserved.includes(:master_film)
  end
end
