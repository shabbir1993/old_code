class FilmsController < ApplicationController
  helper_method :sort_column, :sort_direction

  def index
    safe_scopes = %w(lamination inspection wip fg test nc scrap large_stock
                     small_stock reserved_stock deleted)
    if safe_scopes.include? params[:scope] || params[:scope].nil?
      films = Film.send(params[:scope])
      films = films.search_text(params[:query]) if params[:query].present?
      films = films.min_width(params[:min_width]) if params[:min_width].present?
      films = films.min_length(params[:min_length]) if params[:min_length].present?
      films = films.order(sort_column + " " + sort_direction)
      @films = films.page(params[:page])
      @count = films.count
      @total_area = films.total_area
      respond_to do |format|
        format.html
        format.csv { send_data films.to_csv }
      end
    end
  end

  def edit
    @film = Film.find(params[:id])
    render layout: false
  end

  def update
    @film = Film.find(params[:id])
    @film.update_attributes(params[:film])
  end 

  def edit_multiple
    @films = Film.find(params[:film_ids])
    render layout: false
  end

  def update_multiple
    @films = Film.find(params[:film_ids])
    @films.each do |film|
      film.update_attributes(params[:film].reject { |k,v| v.blank? })
    end
  end

  def split
    @film = Film.find(params[:id])
    @split = Film.new(phase: @film.phase)
    render layout: false
  end

  def create_split
    @film = Film.find(params[:id])
    @film.assign_attributes(params[:film])
    @split = Film.new(params[:film][:split])
    # to trigger validation
    @split.valid?
    if @film.valid? && @split.valid?
      @film.save
      @split.save
    end
  end

  def restore
    @film = Film.find(params[:id])
    @film.update_attributes(deleted: false)
  end

  def unassign
    @film = Film.find(params[:id])
    @film.update_attributes(sales_order_id: nil)
  end

  private

  def sort_column
    default_column = params[:min_width] || params[:min_length] ? "area" : "serial"
    %w(serial width length area shelf sales_order_code note).include?(params[:sort]) ? params[:sort] : default_column
  end

  def sort_direction
    %w(asc desc).include?(params[:direction]) ? params[:direction] : "desc"
  end
end
