class MovementMapData
  def self.for(movements)
    new(movements).map_hash
  end

  def initialize(movements)
    @movements = movements
  end

  def map_hash
    Hash[movements_grouped_by_phase_change.map { |k,v| [k, [(v ? v.count : 0), v.map{ |m| m.area.to_f }.sum.round(2) ]] }]
  end

  private

  def movements_grouped_by_phase_change
    @movements.group_by{ |m| [m.from_phase, m.to_phase] }
  end
end
