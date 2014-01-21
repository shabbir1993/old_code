require 'test_helper'

class SearchMasterFilmsTest < ActionDispatch::IntegrationTest

  before do 
    %w(F0101-02 F0101-03).each do |serial|
      @master_film = FactoryGirl.create(:master_film_with_child, serial: serial)
    end
  end

  describe "searching for F0101-01 to F0101-02 with user authentication" do
    let(:user) { FactoryGirl.create(:user) }

    before do
      log_in(user)
      click_link "Engineering"
      fill_in "Start Serial", with: "F0101-01"
      fill_in "End Serial", with: "F0101-02"
      click_button "Search"
    end

    it "displays the searched films" do
      assert page.has_selector?('.serial', text: "F0101-02")
    end

    it "does not display excluded films" do
      refute page.has_selector?('.serial', text: "F0101-03")
    end
  end
end
