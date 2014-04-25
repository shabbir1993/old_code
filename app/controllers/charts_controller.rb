class ChartsController < ApplicationController
  before_action :set_date_range_to_today, only: :movement_summary
  before_action :set_date_range_to_past_year, only: [:utilization, :yield, :area_shipped, :lead_time]

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
    filtering_params = params.slice(:text_search, :from_phase, :to_phase, :created_at_before, :created_at_after)
    @film_movement_totals_hash = MovementSummaryData.for(TenantAssets.new(current_tenant, FilmMovement).all.exclude_deleted_films.filter(filtering_params).sort_by_created_at)
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

  def lead_time
    @chart = LeadTimeChart.new(current_tenant, params)
  end

  private

  def large_stock_films
    current_tenant.widgets(Film).active.phase('stock').large(current_tenant.small_area_cutoff).not_reserved.joins(:master_film)
  end

  def set_date_range_to_today
    params[:start_date] ||= Date.current.to_s
    params[:end_date] ||= (Date.current + 1).to_s
  end

  def set_date_range_to_past_year
    params[:start_date] ||= (1.year.ago.to_date + 1).to_s
    params[:end_date] ||= (Date.current + 1).to_s
  end
end
