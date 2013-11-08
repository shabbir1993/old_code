require 'test_helper'

describe LineItem do
  let(:line_item) { FactoryGirl.build(:line_item) }

  it "requires a custom_width" do
    line_item.custom_width = nil
    line_item.invalid?(:custom_width).must_equal true
  end

  it "requires a custom_length" do
    line_item.custom_length = nil
    line_item.invalid?(:custom_length).must_equal true
  end

  it "requires a quantity" do
    line_item.quantity = nil
    line_item.invalid?(:quantity).must_equal true
  end

  it "requires a quantity greater than 1" do
    line_item.quantity = 0
    line_item.invalid?(:quantity).must_equal true
  end

  it "is shipped if sales order is shipped" do
    line_item.sales_order.ship_date = Date.today
    line_item.shipped.must_equal true
  end

  it "is not shipped if sales order is not shipped" do
    line_item.sales_order.ship_date = nil
    line_item.shipped.must_equal false
  end

  describe "saved in database" do
    before { line_item.save! }

    it "unfilled returns all unfilled line items" do
      LineItem.unfilled.must_include line_item
    end

    it "unfilled does not return filled line items" do
      line_item.quantity.times do
        FactoryGirl.create(:film, line_item_id: line_item.id)
      end
      LineItem.unfilled.wont_include line_item
    end

    it "assigned film count returns count of assigned films by phase" do
      FactoryGirl.create(:film, line_item_id: line_item.id, phase: "wip")
      FactoryGirl.create(:film, line_item_id: line_item.id, phase: "stock")
      line_item.assigned_film_count("stock").must_equal 1
    end

    it "assigned film percent returns fulfillment percent by phase" do
      line_item.quantity = 2
      line_item.save!
      FactoryGirl.create(:film, line_item_id: line_item.id, phase: "wip")
      FactoryGirl.create(:film, line_item_id: line_item.id, phase: "stock")
      line_item.assigned_film_percent("stock").must_equal 50
    end
  end
end
