require 'spec_helper'

describe "History tab" do
  let(:user) { create(:user) }

  before do
    create(:film_movement, from_phase: "stock", to_phase: "wip")
    create(:film_movement, from_phase: "stock", to_phase: "wip", created_at: 2.days.ago)
    create(:film_movement, from_phase: "stock", to_phase: "fg")
  end

  it "filters records" do
    log_in(user)
    click_link "History"
    click_link "Film movements"
    expect(page).to have_selector("td.serial", count: 3)
    fill_in "query", with: "wip"
    fill_in "start_date", with: 1.days.ago
    click_button "Search"
    expect(page).to have_selector("td.serial", count: 1)
  end
end
