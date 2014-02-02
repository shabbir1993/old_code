require 'test_helper'

class AuthenticationTest < ActionDispatch::IntegrationTest

  describe "login" do
    before do
      @user = FactoryGirl.create(:user)
      visit login_path
    end

    it "logs user in with valid information" do
      fill_in "Username", with: @user.username
      fill_in "Password", with: @user.password
      click_button "Log in"
      assert page.has_content?("Logged in as #{@user.full_name}")
    end

    it "does not log in user and redirects to login with invalid information" do
      fill_in "Username", with: "invalid"
      fill_in "Password", with: "wrong"
      click_button "Log in"
      refute page.has_content?("Logged in as #{@user.full_name}")
      assert page.has_title?("Login")
    end
  end

  describe "with user authentication" do
    let(:user) { FactoryGirl.create(:user) }
    before { log_in(user) }

    it "does not link to admin page" do
      visit root_path
      refute page.has_selector?("a", text: "Admin")
    end

    it "logout link logs user out and redirects to login page" do
      click_link "Logout"
      refute page.has_content?("Logged in as #{user.full_name}")
      assert page.has_title?("Login")
    end

    it "denies access with invalid IP" do
      with_invalid_ip do
        proc { visit root_path }.must_raise(ActionController::RoutingError)
      end
    end
  end

  describe "with admin authentication" do
    let(:admin) { FactoryGirl.create(:admin) }
    before { log_in(admin) }

    it "links to admin page" do
      visit root_path
      assert page.has_selector?("a", text: "Admin")
    end

    it "does not deny access with invalid IP" do
      with_invalid_ip do
        visit root_path
        assert page.has_content?("Logged in as #{admin.full_name}")
      end
    end
  end

  describe "without authentication" do
    it "redirects to login page" do
      visit root_path
      assert page.has_title?("Login")
    end
  end
end
