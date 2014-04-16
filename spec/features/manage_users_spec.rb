describe "Admin Users tab", js: true do
  let(:admin) { FactoryGirl.create(:admin) }

  it "creates edits and deletes users" do
    log_in(admin)
    click_link "Admin"
    click_link "New user"
    fill_in "Full name", with: "Example User"
    fill_in "Username", with: "userfoo"
    fill_in "Password", with: "foobar"
    fill_in "Password confirmation", with: "foobar"
    click_button "Create user"
    within('tr', text: "userfoo") do
      page.find(".edit-user").click
    end
    fill_in "Username", with: "edited_username"
    click_button "Update"
    within('tr', text: "edited_username") do
      page.find(".edit-user").click
    end
    click_link "Delete"
    expect(page).to have_content("deleted")
  end
end
