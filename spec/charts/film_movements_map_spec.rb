require 'spec_helper'

describe FilmMovementsMap do
  fixtures :film_movements

  let(:data) { FilmMovementsMap.new(FilmMovement.all).data }

  it "aggregates movement count and area" do
    expect(data[['stock', 'wip']][:count]).to eq(1)
    expect(data[['stock', 'wip']][:area]).to be_within(0.1).of(41.7)
  end

  it "returns nil if movement doesn't happen" do
    expect(data[['lamination', 'scrap']]).to be_nil
  end
end
