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
end
