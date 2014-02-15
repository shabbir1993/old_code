class StockSnapshotsPresenter
  attr_reader :films

  def initialize(tenant)
    @films = tenant.widgets(Film)
  end

  def for_phase(phase)
    PhaseSnapshot.where(phase: phase).select("count, total_area, created_at").order("created_at ASC")
  end
end
