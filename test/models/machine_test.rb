require 'test_helper'

describe Machine do
  let (:machine) { FactoryGirl.build(:machine) }

  it "requires a code" do
    machine.code = nil
    machine.invalid?(:code).must_equal true
  end

  it "requires a yield constant" do
    machine.yield_constant = nil
    machine.invalid?(:yield_constant).must_equal true
  end
end
