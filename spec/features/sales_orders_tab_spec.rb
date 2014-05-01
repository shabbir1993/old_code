require 'spec_helper'

describe "Orders tab", js: true do
  let(:admin) { create(:admin) }

  before do
    log_in(admin)
    click_link "Orders"
  end

  it "creates edits ships cancels and deletes sales orders" do
    click_link "Enter sales order"
    fill_in "SO#", with: "PT123P"
    fill_in "Customer", with: "Customer"
    fill_in "Ship to", with: "Destination"
    fill_in "Released", with: "2014-01-01"
    fill_in "Due", with: "2014-02-01"
    find(".modal-title").click
    click_link("Add line item")
    fill_in "Width", with: 50
    fill_in "Length", with: 70
    fill_in "Qty", with: 2
    choose("Film")
    click_button "Add sales order"

    within('li', text: "PT123P") do
      page.find(".move-sales-order").click
    end
    click_link "Hold"

    click_link "On Hold"
    within('li', text: "PT123P") do
      page.find(".edit-sales-order").click
    end
    fill_in "Customer", with: "Other Customer"
    click_button "Update"

    within('li', text: "Other Customer") do
      page.find(".move-sales-order").click
      click_link "Ship"
    end
    sleep 0.1
    fill_in "Shipped", with: "2014-02-01"
    click_button "Update"

    click_link "Shipped"
    within('li', text: "PT123P") do
      find(".edit-sales-order").click
    end
    click_link "Delete"
    expect(page).to have_content("Deleted")
  end
end
