class InventoryTotals
  def initialize(movements, tenant)
    @movements = movements
    @tenant = tenant
  end

  def data
    hash = {}
    phases.each do |p|
      daily_totals = current_totals
      ary = []
      dates_in_reverse.each do |d|
        ary << [d.to_datetime.to_i*1000, daily_totals[p].to_f]
        daily_totals = daily_totals.merge(differential_hash(d)) { |k,oldval,newval| oldval + newval }
      end
      hash[p] = ary
    end
    hash
  end

  def phases
    ["reserved", "stock"]
  end

  private

  def current_totals
    ary = phases.map do |p|
      [p, @tenant.films.phase(p).large(@tenant.small_area_cutoff).total_area]
    end
    Hash[ary]
  end

  def differential_hash(date)
    ary = phases.map do |p|
      [p, phase_differential(p, date)]
    end
    Hash[ary]
  end

  def phase_differential(phase, date)
    scoped_movements(date).from_phase(phase).map { |m| m.area }.sum - scoped_movements(date).to_phase(phase).map { |m| m.area }.sum
  end

  def scoped_movements(date)
    @movements.large(@tenant.small_area_cutoff).date_created(date)
  end

  def dates_in_reverse
    (2.months.ago.to_date..Date.today).to_a.reverse
  end
end
