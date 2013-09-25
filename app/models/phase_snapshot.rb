class PhaseSnapshot < ActiveRecord::Base
  attr_accessible :phase, :count, :total_area

  def self.take_all_snapshots
    %w(lamination inspection large_stock reserved_stock small_stock wip fg nc test scrap).each do |scope|
      self.take_snapshot(scope)
    end
  end

  def self.take_snapshot(phase)
    count = Film.send(phase).count
    total_area = Film.send(phase).sum { |f| f.area.to_f }
    self.create!(phase: phase, count: count, total_area: total_area)
  end

  def self.import(file)
    CSV.foreach(file.path, headers: true) do |row|
      record = PhaseSnapshot.new(row.to_hash, without_protection: true)
      record.save!(validate: false)
    end
    ActiveRecord::Base.connection.execute("SELECT setval('phase_snapshots_id_seq', (SELECT MAX(id) FROM phase_snapshots));")
  end
end
