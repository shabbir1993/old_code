require 'test_helper'

describe User do
  let (:user) { FactoryGirl.build(:user) }

  it "requires a full name" do
    user.full_name = nil
    user.invalid?(:full_name).must_equal true
  end

  it "rejects duplicate full names"
  
  it "rejects duplicate usernames"
  
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
  
  it "defaults role level to 0" do
    user.role_level.must_equal 0
  end

  it "defaults chemist to false" do
    user.chemist.must_equal false
  end

  it "defaults operator to false" do
    user.operator.must_equal false
  end

  describe "as chemist but not operator" do
    before do
      user.chemist = true
      user.operator = false
      user.save!
    end

    it "name is included in the chemist list" do
      User.chemists.must_include user.full_name
    end 

    it "name is not included in operator list" do
      User.operators.wont_include user.full_name
    end
  end
  
  describe "as chemist but not operator" do
    before do
      user.chemist = false
      user.operator = true
      user.save!
    end

    it "name is included in operator list" do
      User.operators.must_include user.full_name
    end 

    it "name is not included in chemist list" do
      User.chemists.wont_include user.full_name
    end
  end
end 
