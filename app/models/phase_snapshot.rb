class PhaseSnapshot < ActiveRecord::Base
  attr_accessible :phase, :count, :total_area, :tenant_code

  def self.take_all_snapshots
    Tenant.all.each do |tenant|
      %w(lamination inspection large_stock reserved_stock small_stock wip fg nc test scrap).each do |scope|
        self.take_snapshot(tenant, scope)
      end
    end
  end

  def self.take_snapshot(tenant, phase)
    count = Film.unscoped.send(phase).where(tenant_code: tenant.id).count
    total_area = Film.unscoped.send(phase).where(tenant_code: tenant.id).to_a.sum { |f| f.area.to_f }
    self.create!(phase: phase, count: count, total_area: total_area, tenant_code: tenant.id)
  end

  def tenant
    @tenant || Tenant.new(tenant_code)
  end
end
