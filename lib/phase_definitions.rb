module PhaseDefinitions
  HARD_PHASES = %w(raw lamination inspection stock wip fg nc scrap)

  def self.destinations_for(phase)
    case phase
    when "lamination"
      ["inspection"]
    when "inspection"
      %w{stock wip nc}
    when "stock"
      %w{wip nc}
    when "wip"
      %w{fg stock nc}
    when "fg"
      %w{wip stock nc}
    when "nc"
      %w{scrap stock}
    when "scrap"
      %w{stock nc}
    end
  end

  def self.front_end?(phase)
    %(lamination inspection).include?(phase)
  end
end
