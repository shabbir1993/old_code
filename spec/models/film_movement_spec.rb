require 'spec_helper'
require_relative 'concerns/filterable.rb'

describe FilmMovement do

  it_behaves_like "filterable"
  
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

  describe "#area" do
    it "passes params to the AreaCalculator calculate method" do
      film_movement = build_stubbed(:film_movement)
      tenant = instance_double("Tenant")
      allow(Tenant).to receive(:new).with(film_movement.tenant_code) { tenant }
      allow(tenant).to receive(:area_divisor) { 144 }
      expect(AreaCalculator).to receive(:calculate).with(film_movement.width, film_movement.length, 144)
      film_movement.area
    end
  end

  describe ".to_csv" do
    let(:csv) { FilmMovement.to_csv }

    context "with multiple records" do
      before do
        @first_movement = create(:film_movement)
        @second_movement = create(:film_movement)
      end

      it "returns csv with correct serials" do
        expect(csv).to include(@first_movement.serial, @second_movement.serial)
      end
    end
  end

  describe "#tenant" do
    it "returns the tenant User belongs to" do
      tenant = instance_double("Tenant")
      allow(Tenant).to receive(:new).with('pi') { tenant }
      user = build_stubbed(:user, tenant_code: 'pi')
      expect(user.tenant).to eq(tenant)
    end
  end
end
