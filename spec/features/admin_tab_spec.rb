require 'spec_helper'

describe "Admin tab", js: true do
  let(:admin) { create(:admin) }
  before do 
    log_in(admin) 
    click_link "Admin"
  end

  it "creates edits and deletes users" do
    click_link "New user"
    fill_in "Full name", with: "Example User"
    fill_in "Username", with: "userfoo"
    fill_in "Password", with: "foobar"
    fill_in "Password confirmation", with: "foobar"
    click_button "Create user"

    within('tr', text: "userfoo") do
      find(".edit-user").click
    end
    fill_in "Username", with: "edited_username"
    click_button "Update"

    within('tr', text: "edited_username") do
      find(".edit-user").click
    end
    click_link "Delete"
    expect(page).to have_content("deleted")
  end
end
