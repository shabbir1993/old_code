class Phase
  def initialize(name)
    @name = name
  end

  def valid_destinations
    case @name
    when "lamination"
      ["inspection"]
    when "inspection"
      %w{stock wip test nc}
    when "stock"
      %w{wip test nc}
    when "wip"
      %w{fg stock test nc}
    when "fg"
      %w{wip stock test nc}
    when "test"
      %w{stock nc}
    when "nc"
      %w{scrap stock test}
    when "scrap"
      %w{stock nc test}
    end
  end

  def front_end?
    %(lamination inspection).include?(@name)
  end
end
