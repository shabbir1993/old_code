require 'test_helper'

describe "Authentication integration" do
  describe "with valid IP" do
    before do
      page.driver.options[:headers] = {'REMOTE_ADDR' => "127.0.0.1"}
    end

    describe "with correct http authentication" do
      before { http_login }

      it "allows access to films page" do
        visit films_path(scope: "lamination")
        page.has_selector?(".navbar .brand", text: "PCMS").must_equal true
      end

      it "allows access to imports page" do
        visit imports_path
        page.has_selector?(".navbar .brand", text: "PCMS").must_equal true
      end
    end

    describe "with incorrect http authentication credentials" do
      before { http_login('invaliduser', 'wrongpw') }
      it "denies access to inventory page" do
        visit films_path(scope: "lamination")
        page.has_selector?(".navbar .brand", text: "PCMS").must_equal false
      end

      it "denies access to imports page" do
        visit imports_path
        page.has_selector?(".navbar .brand", text: "PCMS").must_equal false
      end
    end
  end

  it "denies access with invalid IP" do
    page.driver.options[:headers] = {'REMOTE_ADDR' => "1.2.3.4"}
    proc { visit root_path }.must_raise(ActionController::RoutingError)
  end
end
