class ProductionsController < ApplicationController
  before_filter :set_default_start_date

  def index
    @productions = Kaminari.paginate_array(grouped_productions.reverse).page(params[:page])
  end

  def yield_time_series
    @time_series = YieldTimeSeries.new(grouped_productions)
  end

  private
  
  def grouped_productions
    TimeSeriesGrouper.new(filtered_production_master_films, 'serial_date').send(params[:grouping])
  end

  def filtered_production_master_films
    current_tenant.master_films.active.production.filter(filtering_params)
  end

  def set_default_start_date
    params[:serial_date_after] ||= 1.year.ago.to_date
  end

  def filtering_params
    params.slice(:serial_date_before, :serial_date_after)
  end
end
