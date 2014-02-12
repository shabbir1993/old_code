class MovementSummaryPresenter
  attr_reader :movements, :start_date, :end_date

  def initialize(tenant, inputs)
    @movements = tenant.widgets(PaperTrail::Version).exclude_deleted_films.movements
    @start_date = inputs[:start_date] || Date.current.to_s
    @end_date = inputs[:end_date] || (Date.current + 1).to_s
  end

  def film_movement_totals_hash
    Hash[film_movements_by_phase_change.map { |k,v| [k, [(v ? v.count : 0), v.map{ |ver| ver.area_after }.sum.to_f.round(2) ]] }]
  end


  private
  def film_movements_by_phase_change
    movements.search_date_range(start_date, end_date).group_by(&:phase_movement)
  end
end
