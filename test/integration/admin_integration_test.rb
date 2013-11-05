require 'test_helper'

describe "Admin integration" do
  let(:admin) { FactoryGirl.create(:admin) }
  before do
    Capybara.current_driver = Capybara.javascript_driver
    log_in(admin)
    click_link "Admin"
  end

  it "has the right title" do
    assert page.has_title?("Admin")
  end

  it "has an imports page" do
    click_link "Import data"
    assert page.has_selector?("a.active", text: "Import data").must_equal true
  end

  describe "users page" do
    before do 
      @user = FactoryGirl.create(:user)
      FactoryGirl.create(:user)
      click_link "Users"
    end

    it "lists all the users" do
      User.all.each do |user|
        page.has_selector?('td', text: user.username).must_equal true
      end
    end

    describe "new user form" do
      before { click_link "New user" }

      it "creates a new user given valid attributes" do
        fill_in "Full name", with: "New User"
        fill_in "Username", with: "newuser"
        fill_in "Password", with: "foobar"
        fill_in "Password confirmation", with: "foobar"
        select "User", from: "Role"
        check "Chemist"
        check "Operator"
        click_button "Create user"
        within('tr.success') do
          page.has_selector?("td.full_name", text: "New User")
          page.has_selector?("td.username", text: "newuser")
          page.has_selector?("td.chemist", text: "true")
          page.has_selector?("td.operator", text: "true")
        end
      end
      it "displays error messages given invalid attributes" do
        click_button "Create user"
        page.has_selector?('.error-messages', text: "can't be blank").must_equal true
      end
    end

    describe "edit user form" do
      before { click_link "user-#{@user.id}-edit" }

      it "edits existing users given valid attributes" do
        fill_in "Username", with: "newusername"
        select "Supervisor", from: "Role"
        click_button "Update"
        within('tr.info') do
          page.has_selector?('.username', text: "newusername").must_equal true
          page.has_selector?('.role_title', text: "Supervisor").must_equal true
        end 
      end

      it "displays error messages given invalid attributes" do
        fill_in "Username", with: " "
        click_button "Update"
        page.has_selector?('.error-messages', text: "can't be blank").must_equal true
      end

      it "destroys user" do
        click_link "Delete"
        page.has_selector?('.alert-success', text: "#{@user.full_name} deleted").must_equal true
      end
    end
  end
end
