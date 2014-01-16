require 'test_helper'

class EnterUserTest < ActionDispatch::IntegrationTest

  before { use_javascript_driver }

  describe "User entry form with admin authentication" do
    let(:admin) { FactoryGirl.create(:admin) }

    before do
      log_in(admin)
      click_link "Admin"
      click_link "Users"
      click_link "New user"
    end

    it "creates a new user given valid attributes" do
      fill_in 'Full name', with: "New User"
      fill_in 'Username', with: "username"
      fill_in 'Password', with: "foobar"
      fill_in 'Password confirmation', with: "foobar"
      click_button 'Create user'
      within("tr.success") do
        assert page.has_content?("New User")
        assert page.has_content?("username")
      end
    end

    it "displays error messages given invalid attributes" do
      click_button 'Create user'
      assert page.has_selector?('.error-messages')
    end
  end
end
