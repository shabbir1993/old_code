class InventoryTotals
  def initialize(movements, tenant)
    @movements = movements
    @tenant = tenant
  end

  def data
    hash = {}
    daily_totals = current_totals
    phases.each do |p|
      hash[p] = dates_in_reverse.map do |d|
        daily_totals = daily_totals.merge(differential_hash(d)) { |k,oldval,newval| oldval + newval }
        [d.to_datetime.to_i*1000, daily_totals[p].to_f]
      end
    end
    hash
  end

  def phases
    ["reserved", "stock"]
  end

  private

  def current_totals
    ary = phases.map do |p|
      [p, @tenant.films.large(@tenant.small_area_cutoff).phase(p, @tenant).total_area]
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
    scoped_movements(date).to_phase(phase).map { |m| m.area }.sum - scoped_movements(date).from_phase(phase).map { |m| m.area }.sum
  end

  def scoped_movements(date)
    @movements.large(@tenant.small_area_cutoff).date_created(date)
  end

  def dates_in_reverse
    (2.months.ago.to_date..Date.today).to_a.reverse
  end
end
