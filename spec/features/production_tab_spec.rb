require 'spec_helper'

describe "Production tab", js: true do
  let(:admin) { create(:admin) }

  before do
    log_in(admin)
    click_link "Production"
  end

  it "edits moves splits filters and deletes films" do
    film_1 = create(:film, phase: "lamination")
    film_2 = create(:film, phase: "lamination")
    click_link "Lamination"

    within('tr', text: film_1.serial) do
      find(".film-select").click
    end
    within('tr', text: film_2.serial) do
      find(".film-select").click
    end
    click_button "Move selected"
    select "inspection", from: "film_destination"
    click_button "Move all"

    click_link "Inspection"
    expect(page).to have_content(film_2.serial)
    fill_in "Search", with: film_1.serial
    click_button "Search"
    expect(page).to_not have_content(film_2.serial)
    
    click_link "film-#{film_1.id}-edit"
    select "stock", from: "film_destination"
    click_button "Update"

    click_link "Available"
    expect(page).to have_selector("tr.film", count: 1)
    click_link "film-#{film_1.id}-split"
    expect(page).to have_selector("tr.film", count: 2)
  end
end
