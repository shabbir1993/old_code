require 'spec_helper'

describe TimeSeriesGrouper do

  describe "#by_day" do
    let(:start_date) { Date.today.to_s }
    let(:end_date) { Date.tomorrow.to_s }
    let(:grouped_orders) { TimeSeriesGrouper.new(SalesOrder.shipped, 'ship_date', start_date, end_date).by_day }
    before do
      @sales_order = create(:sales_order, status: 'shipped', ship_date: Date.today)
    end

    it "groups relations by day" do
      expect(grouped_orders.first[:relation].all).to include(@sales_order)
      expect(grouped_orders.last[:relation].all).to_not include(@sales_order)
    end

    it "sets the sort date" do
      expect(grouped_orders.first[:sort_date]).to eq(Date.today)
    end

    it "sets the display date" do
      expect(grouped_orders.first[:display_date]).to eq(Date.today.strftime('%D'))
    end
  end

  describe "#by_week" do
    let(:start_date) { Date.today.to_s }
    let(:end_date) { (Date.today.end_of_week + 1).to_s }
    let(:grouped_orders) { TimeSeriesGrouper.new(SalesOrder.shipped, 'ship_date', start_date, end_date).by_week }
    before do
      @sales_order = create(:sales_order, status: 'shipped', ship_date: Date.today)
    end

    it "groups relations by week" do
      expect(grouped_orders.first[:relation].all).to include(@sales_order)
      expect(grouped_orders.last[:relation].all).to_not include(@sales_order)
    end

    it "sets the sort date" do
      expect(grouped_orders.first[:sort_date]).to eq(Date.today.beginning_of_week)
    end

    it "sets the display date" do
      expect(grouped_orders.first[:display_date]).to eq("#{Date.today.beginning_of_week.strftime('%D')} - #{Date.today.end_of_week.strftime('%D')}")
    end
  end

  describe "#group_by_month" do
    let(:start_date) { Date.today.to_s }
    let(:end_date) { (Date.today.end_of_month + 1).to_s }
    let(:grouped_orders) { TimeSeriesGrouper.new(SalesOrder.shipped, 'ship_date', start_date, end_date).by_month }
    before do
      @sales_order = create(:sales_order, status: 'shipped', ship_date: Date.today)
    end

    it "groups relations by month" do
      expect(grouped_orders.first[:relation].all).to include(@sales_order)
      expect(grouped_orders.last[:relation].all).to_not include(@sales_order)
    end

    it "sets the sort date" do
      expect(grouped_orders.first[:sort_date]).to eq(Date.today.beginning_of_month)
    end

    it "sets the display date" do
      expect(grouped_orders.first[:display_date]).to eq(Date.today.strftime('%B %Y'))
    end
  end

  describe "#group_by_quarter" do
    let(:start_date) { Date.today.to_s }
    let(:end_date) { (Date.today.end_of_quarter + 1).to_s }
    let(:grouped_orders) { TimeSeriesGrouper.new(SalesOrder.shipped, 'ship_date', start_date, end_date).by_quarter }
    before do
      @sales_order = create(:sales_order, status: 'shipped', ship_date: Date.today)
    end

    it "groups relations by quarter" do
      expect(grouped_orders.first[:relation].all).to include(@sales_order)
      expect(grouped_orders.last[:relation].all).to_not include(@sales_order)
    end

    it "sets the sort date" do
      expect(grouped_orders.first[:sort_date]).to eq(Date.today.beginning_of_quarter)
    end

    it "sets the display date"
  end
end
