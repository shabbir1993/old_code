class FilmsPresenter
  include Exportable
  include ActionView::Helpers::NumberHelper

  attr_reader :tenant, :films, :tab, :query, :min_width, :min_length, :sort, :direction

  SAFE_SCOPES = %w(lamination inspection wip fg test nc scrap large_stock small_stock reserved_stock deleted)
  SAFE_SORTS = %w(serial width length area shelf sales_order_code note) 

  def initialize(tenant, inputs)
    @tenant = tenant
    @films = tenant.widgets(Film)
    @tab = inputs[:tab]
    @query = inputs[:query]
    @min_width = inputs[:min_width]
    @min_length = inputs[:min_length]
    @sort = inputs[:sort]
    @direction = inputs[:direction]
  end

  def present
    @results ||= films_for_tab(tab).search_text(query)
                                   .search_dimensions(min_width, min_length)
                                   .order("#{safe_sort} #{safe_direction}")
  end

  def total_count
    films.count
  end

  def total_area
    number_with_precision(films.map{ |f| f.area.to_f }.sum, precision: 2)
  end

  def films_for_tab(tab)
    case tab
    when "lamination", "inspection", "wip", "fg", "test", "nc", "scrap"
      films.active.phase(tab)
    when "large_stock"
      films.active.phase("stock").large(tenant.small_area_cutoff).not_reserved
    when "small_stock"
      films.active.phase("stock").small(tenant.small_area_cutoff).not_reserved
    when "reserved_stock"
      films.active.phase("stock").reserved
    when "deleted"
      films.deleted
    else 
      films.active.phase("lamination")
    end
  end

  def data_for_export
    data = [] << %w(Serial Formula Width Length Area Shelf SO Phase)
    present.limit(5000).each do |f|
      data << [f.serial, f.formula, f.width, f.length, f.area, f.shelf, f.sales_order_code, f.phase]
    end
    data
  end

  private

  def safe_sort
    SAFE_SORTS.include?(sort) ? sort : ""
  end

  def safe_direction
    %w(asc desc).include?(direction) ? direction : ""
  end
end
