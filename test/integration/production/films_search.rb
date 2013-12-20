require 'test_helper'

describe "Films search integration" do
  before do 
    @tenant = FactoryGirl.create(:tenant)
    @film1 = FactoryGirl.create(:film, phase: "stock", shelf: "A", 
                                width: 50, length: 80, tenant: @tenant)
    @film2 = FactoryGirl.create(:film, phase: "stock", shelf: "A", 
                                width: 55, length: 80, tenant: @tenant)
    @film3 = FactoryGirl.create(:film, phase: "stock", shelf: "A", 
                                width: 50, length: 85, tenant: @tenant)
    @film4 = FactoryGirl.create(:film, phase: "stock", shelf: "C", 
                                width: 50, length: 80, tenant: @tenant)
  end

  describe "searching for text and dimension ranges with supervisor auth" do
    let(:supervisor) { FactoryGirl.create(:supervisor, tenant: @tenant) }

    before do
      log_in(supervisor)
      click_link "Production"
      click_link "Available"
      fill_in "query", with: "A"
      fill_in "min-width", with: 48
      fill_in "max-width", with: 52
      fill_in "min-length", with: 78
      fill_in "max-length", with: 82
      click_button "Search"
    end

    it "displays the searched films" do
      assert page.has_selector?('td.serial', text: @film1.serial)
    end

    it "does not display excluded films" do
      refute page.has_selector?('td.serial', text: @film2.serial)
      refute page.has_selector?('td.serial', text: @film3.serial)
      refute page.has_selector?('td.serial', text: @film4.serial)
    end
  end
end
