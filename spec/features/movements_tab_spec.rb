require 'spec_helper'

describe "Movements tab" do
  let(:user) { create(:user) }

  before do
    log_in(user)
    click_link "Movements"
  end

  it "filters and displays film movements" do
    create(:film_movement, from_phase: "stock", to_phase: "wip")
    create(:film_movement, from_phase: "stock", to_phase: "fg")
    click_link "Film movements"
    expect(page).to have_selector("td.serial", count: 2)
    fill_in "text_search", with: "wip"
    click_button "Search"
    expect(page).to have_selector("td.serial", count: 1)
  end
end
