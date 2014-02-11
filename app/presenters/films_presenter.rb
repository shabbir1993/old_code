class FilmsPresenter
  include ActionView::Helpers::NumberHelper

  attr_reader :films, :phase, :query, :min_width, :min_length, :sort, :direction

  SAFE_SCOPES = %w(lamination inspection wip fg test nc scrap large_stock small_stock reserved_stock deleted)
  SAFE_SORTS = %w(serial width length area shelf sales_order_code note) 

  def initialize(tenant, inputs)
    @films = tenant.widgets(Film)
    @phase = inputs[:phase]
    @query = inputs[:query]
    @min_width = inputs[:min_width]
    @min_length = inputs[:min_length]
    @sort = inputs[:sort]
    @direction = inputs[:direction]
  end

  def present
    if SAFE_SCOPES.include?(phase)
      @results ||= films.send(phase)
                        .search_text(query)
                        .search_dimensions(min_width, min_length)
                        .order("#{sort_column} #{sort_direction}")
    end
  end

  def total_count
    films.count
  end

  def total_area
    number_with_precision(films.map{ |f| f.area.to_f }.sum, precision: 2)
  end

  private

  def sort_column
    SAFE_SORTS.include?(sort) ? sort : ""
  end

  def sort_direction
    %w(asc desc).include?(direction) ? direction : ""
  end
end
