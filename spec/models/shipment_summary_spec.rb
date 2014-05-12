require 'spec_helper'

describe ShipmentSummary do
  fixtures :all

  let(:tenant) { Tenant.new('pi') }

  describe "#by_day" do
    let(:day_summary) { ShipmentSummary.new(tenant).by_day.first }

    it "returns a hash of daily shipment data" do
      expect(day_summary[:date]).to eq(Date.parse('2013-1-20'))
      expect(day_summary[:order_count]).to eq(1)
      expect(day_summary[:film_pieces]).to eq(0)
      expect(day_summary[:glass_pieces]).to eq(3)
      expect(day_summary[:total_pieces]).to eq(3)
      expect(day_summary[:film_area]).to be_within(0.1).of 0
      expect(day_summary[:glass_area]).to be_within(0.1).of 66.7
      expect(day_summary[:total_area]).to be_within(0.1).of 66.7
      expect(day_summary[:avg_utilization]).to be_within(0.1).of 160
      expect(day_summary[:orders]).to eq([sales_orders(:shipped)])
    end
  end

  describe "#by_week" do
    it "returns a hash of weekly shipment data" do
    end
  end

  describe "#by_month" do
    it "returns a hash of monthly shipment data" do
    end
  end
end
