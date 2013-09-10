require 'test_helper'

describe "Authentication integration" do
  describe "with valid IP" do
    before do
      page.driver.options[:headers] = {'REMOTE_ADDR' => "127.0.0.1"}
    end

    describe "with correct http authentication" do
      before { http_login }

      it "allows access to inventory page" do
        visit root_path
        click_link "Inventory"
        page.has_selector?(".navbar .brand", text: "PCMS").must_equal true
      end

      it "allows access to history page" do
        visit root_path
        click_link "History"
        page.has_selector?(".navbar .brand", text: "PCMS").must_equal true
      end

      it "allows access to charts page" do
        visit root_path
        click_link "Charts"
        page.has_selector?(".navbar .brand", text: "PCMS").must_equal true
      end

      it "allows access to admin page" do
        visit root_path
        click_link "Admin"
        page.has_selector?(".navbar .brand", text: "PCMS").must_equal true
      end
    end

    it "denies access with invalid http auth" do
      http_login('invaliduser', 'wrongpw')
      visit root_path
      page.has_selector?(".navbar .brand", text: "PCMS").must_equal false
    end
  end

  it "denies access with invalid IP" do
    page.driver.options[:headers] = {'REMOTE_ADDR' => "1.2.3.4"}
    proc { visit root_path }.must_raise(ActionController::RoutingError)
  end
end
