require 'test_helper'

describe AuthChecker do
  def mock_user(admin)
    Class.new { define_method(:is_admin?) { admin } }.new
  end

  before { @valid_ip = "127.0.0.1" }

  describe "with user login" do
    before do
      @user = mock_user(false)
    end

    it "grants access with valid ip" do
      @auth_checker = AuthChecker.new(@user, @valid_ip)
      @auth_checker.grant_access?.must_equal true
    end

    it "denies access" do
      @auth_checker = AuthChecker.new(@user, "invalid")
      @auth_checker.grant_access?.wont_equal true
    end
  end

  describe "with admin login" do
    before do
      @user = mock_user(true)
    end
    it "grants access with valid ip" do
      @auth_checker = AuthChecker.new(@user, @valid_ip)
      @auth_checker.grant_access?.must_equal true
    end

    it "grants access with invalid ip" do
      @auth_checker = AuthChecker.new(@user, "invalid")
      @auth_checker.grant_access?.must_equal true
    end
  end

  describe "without login" do
    it "denies access with valid ip" do
      @auth_checker = AuthChecker.new(nil, @valid_ip)
      @auth_checker.grant_access?.wont_equal true
    end
    it "denies access with invalid ip" do
      @auth_checker = AuthChecker.new(nil, "invalid")
      @auth_checker.grant_access?.wont_equal true
    end
  end
end
