require 'spec_helper'

describe LeadTimeHistogram do
  fixtures :sales_orders

  let(:histogram) { LeadTimeHistogram.new(SalesOrder.all) }

  describe "#lead_day_range" do
    it "returns array of lead day range" do
      expect(histogram.lead_day_range).to eq((0..19).to_a)
    end
  end

  describe "#data" do
    it "returns hash of lead days by code prefix" do
      pt_ary = []
      19.times { pt_ary << 0 }
      pt_ary << 1
      expect(histogram.data).to eq(pt_ary)
    end
  end
end
