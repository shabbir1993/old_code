class ProductionsController < ApplicationController

  def index
    @productions = Kaminari.paginate_array(grouped_productions.reverse).page(params[:page])
  end

  def yield_time_series
    @time_series = YieldTimeSeries.new(grouped_productions)
  end

  private
  
  def grouped_productions
    RelationGrouper.new(production_master_films, 'serial_date', params[:start_date], params[:end_date]).send(params[:grouping])
  end

  def production_master_films
    current_tenant.master_films.active.production
  end
end
