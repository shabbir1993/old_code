require 'test_helper'

describe User do
  let (:user) { FactoryGirl.build(:user) }

  it "requires a username" do
    user.username = nil
    user.invalid?(:username).must_equal true
  end

  it "requires a full name" do
    user.full_name = nil
    user.invalid?(:full_name).must_equal true
  end
  
  it "knows whether or not user is supervisor" do
    user.role_level = 1
    user.is_supervisor?.must_equal true
    user.role_level = 2
    user.is_supervisor?.must_equal true
  end

  it "knows whether or not user is admin" do
    user.role_level = 2
    user.is_admin?.must_equal true
  end

  it "defaults chemist to false" do
    user.chemist.must_equal false
  end

  it "defaults operator to false" do
    user.operator.must_equal false
  end

  it "defaults active to true" do
    user.active.must_equal true
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
