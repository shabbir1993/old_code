describe Machine do
  let (:machine) { FactoryGirl.build(:machine) }

  it "requires a code" do
    machine.code = nil
    machine.invalid?(:code).must_equal true
  end
end
