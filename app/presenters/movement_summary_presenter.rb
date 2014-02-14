class MovementSummaryPresenter
  attr_reader :movements, :start_date, :end_date

  def initialize(tenant, inputs)
    @movements = tenant.widgets(FilmMovement).exclude_deleted_films
    @start_date = inputs[:start_date] || Date.current.to_s
    @end_date = inputs[:end_date] || (Date.current + 1).to_s
  end

  def film_movement_totals_hash
    Hash[film_movements_by_phase_change.map { |k,v| [k, [(v ? v.count : 0), v.map{ |m| m.area.to_f }.sum.round(2) ]] }]
  end


  private
  def film_movements_by_phase_change
    Rails.logger.debug "YAY"
    movements.search_date_range(start_date, end_date).group_by{ |m| [m.from_phase, m.to_phase] }
  end
end
