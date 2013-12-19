require 'test_helper'

describe "Master films search integration" do

  before do 
    @tenant = FactoryGirl.create(:tenant)
    %w(F0101-01 F0101-02 F0101-03).each do |serial|
      @master_film = FactoryGirl.create(:master_film_with_child, serial: serial, tenant: @tenant)
    end
  end

  describe "searching for F0101-01 to F0101-02 with supervisor authentication" do
    let(:supervisor) { FactoryGirl.create(:supervisor, tenant: @tenant) }

    before do
      log_in(supervisor)
      click_link "Engineering"
      fill_in "Start Serial", with: "F0101-01"
      fill_in "End Serial", with: "F0101-02"
      click_button "Search"
    end

    it "displays the searched films" do
      page.has_selector?('td.serial', text: "F0101-01").must_equal true
      page.has_selector?('td.serial', text: "F0101-02").must_equal true
    end

    it "does not display excluded films" do
      page.has_selector?('td.serial', text: "F0101-03").wont_equal true
    end
  end
end
