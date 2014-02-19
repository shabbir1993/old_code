require 'test_helper'

class SearchFilmsTest < ActionDispatch::IntegrationTest

  describe "searching for text and dimension ranges" do
    let(:user) { FactoryGirl.create(:user) }

    before do
      @film1 = FactoryGirl.create(:film, phase: "stock", shelf: "A", width: 55, length: 85)
      @film2 = FactoryGirl.create(:film, phase: "stock", shelf: "B", width: 55, length: 80)
      log_in(user)
      click_link "Production"
      click_link "Available"
      fill_in "query", with: "A"
      fill_in "formula", with: ""
      fill_in "min_width", with: 52
      fill_in "min_length", with: 83
      click_button "Search"
    end

    it "displays the searched films" do
      assert page.has_selector?("#film-#{@film1.id}")
    end

    it "does not display excluded films" do
      refute page.has_selector?("#film-#{@film2.id}")
    end
  end
end
