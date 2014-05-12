require 'spec_helper'

describe LineItem do
  fixtures :line_items, :sales_orders

  describe "#custom_area" do
    it "calculates custom area" do
      expect(line_items(:film).custom_area).to be_within(0.1).of 24.3
    end
  end

  describe "#total_area" do
    it "calculates sum of custom areas" do
      expect(line_items(:film).total_area).to be_within(0.1).of 48.6
    end
  end

  describe ".total_area" do
    it "calculates the sum of total areas" do
      expect(LineItem.total_area).to be_within(0.1).of 115.3
    end
  end

  describe ".total_quantity" do
    it "calculates the sum of quantities" do
      expect(LineItem.total_quantity).to eq(5)
    end
  end

  describe ".to_csv" do
    let(:csv) { LineItem.to_csv }

    it "returns csv with correct serials" do
      expect(csv).to include(line_items(:glass).product_type, line_items(:film).product_type)
    end
  end

  describe "#tenant" do
    it "returns the sales order tenant" do
      expect(line_items(:film).tenant.code).to eq('pi')
    end
  end
end
