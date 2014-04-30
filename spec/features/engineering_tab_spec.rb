require 'spec_helper'

describe "Engineering tab", js: true do
  let(:admin) { create(:admin) }

  before do
    log_in(admin)
    click_link "Engineering"
  end

  it "creates and edits master films" do
    click_link "Enter film"
    fill_in "Serial", with: "F1231-01"
    click_button "Add film"

    within('tr', text: "F1231-01") do
      page.find(".edit-master-film").click
    end
    sleep 0.01
    click_link "Add defect"
    select "Clear Spot", from: "master_film_defects_key"
    fill_in "Count", with: 2
    click_button "Update"

    within('tr', text: "F1231-01") do
      expect(page).to have_selector(".defects_sum", text: "2")
    end
  end
end
