require 'test_helper'

describe "Authentication integration" do
  describe "with valid IP" do
    before do
      page.driver.options[:headers] = {'REMOTE_ADDR' => "127.0.0.1"}
    end

    describe "login" do
      let(:user) { FactoryGirl.create(:user) }
      before do
        visit login_path
      end

      it "has the right title" do
        page.has_title?("Login").must_equal true
      end

      it "logs user in with valid information" do
        fill_in "Username", with: user.username
        fill_in "Password", with: user.password
        click_button "Log in"
        page.has_selector?(".navbar-brand", text: "PCMS").must_equal true
      end

      it "does not log in user with invalid information" do
        fill_in "Username", with: "invalid_username"
        fill_in "Password", with: "invalid_password"
        click_button "Log in"
        page.has_selector?(".navbar-brand", text: "PCMS").must_equal false
        page.has_selector?(".alert", text: "Invalid login").must_equal true
      end
    end

    describe "with user authentication" do
      let(:user) { FactoryGirl.create(:user) }
      before { log_in(user) }

      it "allows access to production page" do
        visit root_path
        click_link "Production"
        page.has_selector?(".navbar .navbar-brand", text: "PCMS").must_equal true
      end

      it "allows access to history page" do
        visit root_path
        click_link "History"
        page.has_selector?(".navbar .navbar-brand", text: "PCMS").must_equal true
      end

      it "allows access to charts page" do
        visit root_path
        click_link "Charts"
        page.has_selector?(".navbar .navbar-brand", text: "PCMS").must_equal true
      end

      it "allows access to orders page" do
        visit root_path
        click_link "Orders"
        page.has_selector?(".navbar .navbar-brand", text: "PCMS").must_equal true
      end

      it "does not link to admin page" do
        visit root_path
        page.has_selector?(".navbar a", text: "Admin").must_equal false
      end

      it "logout link logs user out" do
        within('.navbar') do
          click_link "Logout"
        end
        page.has_title?("Login").must_equal true
      end
    end

    describe "with admin authentication" do
      let(:admin) { FactoryGirl.create(:admin) }
      before { log_in(admin) }

      it "allows access to admin page" do
        visit root_path
        click_link "Admin"
        page.has_selector?(".navbar .navbar-brand", text: "PCMS").must_equal true
      end
    end

    describe "without authentication" do
      it "redirects to login page" do
        visit root_path
        page.has_title?("Login").must_equal true
      end
    end
  end

  it "denies access with invalid IP" do
    page.driver.options[:headers] = {'REMOTE_ADDR' => "1.2.3.4"}
    proc { visit root_path }.must_raise(ActionController::RoutingError)
  end
end
