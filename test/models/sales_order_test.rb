require 'test_helper'

describe SalesOrder do
  let(:sales_order) { FactoryGirl.build(:sales_order) }

  it "requires a code" do
    sales_order.code = nil
    sales_order.invalid?(:code).must_equal true
  end

  it "accepts valid codes" do
    valid_codes = ["PT123P", "SE444Q"]
    valid_codes.each do |code|
      proc { FactoryGirl.create(:sales_order, code: code) }.must_be_silent
    end
  end

  it "rejects invalid codes" do
    invalid_codes = ["pt123P", "PET321G", "PT1234P", "PT123PE"]
    invalid_codes.each do |code|
      proc { FactoryGirl.create(:sales_order, code: code) }.must_raise ActiveRecord::RecordInvalid
    end
  end

  it "rejects duplicate codes" do
    FactoryGirl.create(:sales_order, code: sales_order.code)
    sales_order.invalid?(:code).must_equal true
  end

  it "requires a customer" do
    sales_order.customer = nil
    sales_order.invalid?(:customer).must_equal true
  end

  it "creates nested line items" do
    before_count = LineItem.count
    FactoryGirl.create(:sales_order, line_items_attributes: [FactoryGirl.attributes_for(:line_item)])
    LineItem.count.must_equal before_count + 1
  end

  it "destroys nested line_items" do
    sales_order.save!
    line_item = FactoryGirl.create(:line_item, sales_order_id: sales_order.id)
    sales_order.reload.line_items.length.must_equal 1
    sales_order.line_items_attributes = [FactoryGirl.attributes_for(:line_item, id: line_item.id, _destroy: '1')]
    sales_order.save!
    sales_order.reload.line_items.length.must_equal 0
  end

  it "by_code scope orders by code" do
    ["PT123P", "PE321P", "SE555N"].each do |code|
      FactoryGirl.create(:sales_order, code: code)
    end
    SalesOrder.by_code.pluck(:code).must_equal ["PE321P", "PT123P", "SE555N"]
  end

  describe "saved in database" do
    before { sales_order.save! }

    it "calculates total films needed" do
      2.times do
        FactoryGirl.create(:line_item, quantity: 3, sales_order_id: sales_order.id)
      end
      sales_order.total_quantity.must_equal 6
    end

    describe "with line items and assigned films" do
      before do
        line_item_1 = FactoryGirl.create(:line_item, quantity: 2, sales_order_id: sales_order.id)
        line_item_2 = FactoryGirl.create(:line_item, quantity: 2, sales_order_id: sales_order.id)
        FactoryGirl.create(:film, line_item: line_item_1, phase: "stock")
        FactoryGirl.create(:film, line_item: line_item_2, phase: "stock")
        FactoryGirl.create(:film, line_item: line_item_2, phase: "wip")
      end

      it "calculates total films assigned by phase" do
        sales_order.total_assigned_film_count("stock").must_equal 2
      end

      it "calculates percent completed by phase" do
        sales_order.total_assigned_film_percent("stock").must_equal 50
      end
    end
  end
end
