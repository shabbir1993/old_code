describe Defect do
  let (:defect) { FactoryGirl.build(:defect) }

  it "requires a defect type" do
    defect.defect_type = nil
    defect.invalid?(:type).must_equal true
  end

  it "requires a count" do
    defect.count = nil
    defect.invalid?(:count).must_equal true
  end

  it "requires a master film id" do
    defect.master_film_id = nil
    defect.invalid?(:master_film_id).must_equal true
  end

  it "has an allowed_types that returns an array" do
    Defect.allowed_types.must_be_instance_of Array
  end
end
