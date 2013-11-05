class PhaseSnapshot < ActiveRecord::Base
  attr_accessible :phase, :count, :total_area

  def self.take_all_snapshots
    %w(lamination inspection large_stock reserved_stock small_stock wip fg nc test scrap).each do |scope|
      self.take_snapshot(scope)
    end
  end

  def self.take_snapshot(phase)
    count = Film.send(phase).count
    total_area = Film.send(phase).to_a.sum { |f| f.area.to_f }
    self.create!(phase: phase, count: count, total_area: total_area)
  end
end
