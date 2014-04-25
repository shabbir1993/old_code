require 'spec_helper'

describe "History tab" do
  let(:user) { create(:user) }

  before do
    create(:film_movement, from_phase: "stock", to_phase: "wip")
    create(:film_movement, from_phase: "stock", to_phase: "fg")
  end

  it "filters records" do
    log_in(user)
    click_link "History"
    click_link "Film movements"
    expect(page).to have_selector("td.serial", count: 2)
    fill_in "text_search", with: "wip"
    click_button "Search"
    expect(page).to have_selector("td.serial", count: 1)
  end
end
