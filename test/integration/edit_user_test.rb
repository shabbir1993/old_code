require 'test_helper'

class EditUserTest < ActionDispatch::IntegrationTest

  before do 
    use_javascript_driver
    @user = FactoryGirl.create(:user)
  end

  describe "edit user form with admin authentication" do
    let(:admin) { FactoryGirl.create(:admin) }

    before do
      log_in(admin)
      click_link "Admin"
      click_link "Users"
      click_link "user-#{@user.id}-edit"
    end

    it "updates user given valid attributes" do
      fill_in 'Username', with: "New username"
      click_button 'Update'
      assert page.has_selector?("#user-#{@user.id}", text: "New username")
    end

    it "displays error messages given invalid attributes" do
      fill_in 'Username', with: ""
      click_button 'Update'
      assert page.has_selector?('.error-messages')
    end
  end
end
