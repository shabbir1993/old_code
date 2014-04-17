require 'spec_helper'

describe "Logging in and out" do
  let(:user) { create(:user) }

  it "creates edits and deletes users" do
    visit login_path
    fill_in "Username", with: user.username
    fill_in "Password", with: user.password
    click_button "Log in"
    click_link "Logout"
    expect(page).to have_content(/logged out/i)
  end
end

