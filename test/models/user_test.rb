require 'test_helper'

describe User do
  let (:user) { FactoryGirl.build(:user) }

  it "requires a email" do
    user.email = nil
    user.invalid?(:email).must_equal true
  end

  it "requires a name" do
    user.name = nil
    user.invalid?(:name).must_equal true
  end

  it "defaults chemist to false" do
    user.chemist.must_equal false
  end

  it "defaults operator to false" do
    user.operator.must_equal false
  end

  it "chemists scope should include chemists" do
    user.chemist = true
    user.save!
    User.chemists.must_include user
  end 

  it "chemists scope should not include non-chemists" do
    user.chemist = false
    user.save!
    User.chemists.wont_include user
  end
  
  it "operators scope should include operators" do
    user.operator = true
    user.save!
    User.operators.must_include user
  end 

  it "operators scope should not include non-operators" do
    user.operator = false
    user.save!
    User.operators.wont_include user
  end
end 
