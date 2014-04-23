require 'spec_helper'

describe FilmMovement do
  describe "#datetime_display" do
    context "created_at year is current year" do
      let(:current_year) { Time.zone.today.year }

      before do
        @current_year_movement = build_stubbed(:film_movement, created_at: Time.zone.local(current_year, 1, 2, 7))
      end

      it "displays created_at as date, month, and time" do
        expect(@current_year_movement.datetime_display).to match(/2 Jan 07:00/i)
      end
    end

    context "created_at year is not current year" do
      let(:last_year) { Time.zone.today.year - 1 }

      before do
        @last_year_movement = create(:film_movement, created_at: Time.zone.local(last_year, 1, 2, 7))
      end

      it "displays created_at as shortened date with time" do
        expect(@last_year_movement.datetime_display).to match(/#{last_year}-01-02 07:00/)
      end
    end
  end
end
