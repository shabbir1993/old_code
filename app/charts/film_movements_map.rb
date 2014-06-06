class FilmMovementsMap
  def initialize(movements)
    @movements = movements
  end

  def categories
    %w(raw lamination inspection stock wip fg nc scrap)
  end

  def data
    ary = movements_grouped_by_phase_change.map do |k,v|
      [k, { count: v.count, area: sum_areas(v).round(2) }]
    end
    Hash[ary]
  end

  private

  def movements_grouped_by_phase_change
    @movements.group_by { |m| [m.from_phase, m.to_phase] }
  end

  def sum_areas(movements)
    movements.inject(0) { |t,m| t + m.area }
  end
end
