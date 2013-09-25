require 'test_helper'

describe PhaseSnapshot do
  it "records the count and total area of a phase" do
    @film1 = FactoryGirl.create(:film, phase: "wip", width: 60, length: 60)
    @film2 = FactoryGirl.create(:film, phase: "wip", width: 60, length: 60)
    @snapshot = PhaseSnapshot.take_snapshot("wip")
    @snapshot.phase.must_equal "wip" 
    @snapshot.count.must_equal 2
    @snapshot.total_area.must_equal 50
  end
end
