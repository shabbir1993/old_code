module PhaseDefinitions
  HARD_PHASES = %w(raw lamination inspection stock reserved wip fg nc scrap)

  def self.destinations_for(phase)
    case phase
    when "lamination"
      ["inspection"]
    when "inspection"
      %w{stock reserved wip nc}
    when "stock"
      %w{reserved wip nc}
    when "wip"
      %w{fg reserved stock nc}
    when "fg"
      %w{wip stock reserved nc}
    when "nc"
      %w{scrap stock reserved}
    when "scrap"
      %w{stock reserved nc}
    end
  end

  def self.front_end?(phase)
    %(lamination inspection).include?(phase)
  end
end
