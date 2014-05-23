require 'spec_helper'

describe RelationGrouper do

  describe "#group_by_day" do
    let(:grouped_orders) { RelationGrouper.new(SalesOrder.shipped, 'ship_date').group_by_day }
    before do
      @sales_order = create(:sales_order, status: 'shipped', ship_date: Date.today)
    end

    it "groups relations by day" do
      expect(grouped_orders.first).to include(@sales_order)
    end

    it "sets the start date" do
      expect(grouped_orders.first.group_start_date).to eq(Date.today)
    end

    it "sets the display date"
  end
end
