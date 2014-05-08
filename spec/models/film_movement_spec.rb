require 'spec_helper'

describe FilmMovement do
  fixtures :film_movements
  fixtures :films
  fixtures :master_films

  describe "#area" do
    context "with width and length" do
      it "calculates the area" do
        expect(film_movements(:stock_to_wip).area).to be_within(0.1).of(41.7)
      end
    end

    context "without width and length" do
      it "returns 0" do
        expect(film_movements(:lamination_to_inspection).area).to eq(0)
      end
    end
  end

  describe ".to_csv" do
    let(:csv) { FilmMovement.to_csv }

    it "returns csv with correct serials" do
      expect(csv).to include(film_movements(:stock_to_wip).serial, film_movements(:lamination_to_inspection).serial)
    end
  end
end
