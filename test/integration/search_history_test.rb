require 'test_helper'

class SearchHistoryTest < ActionDispatch::IntegrationTest
  before do
    @film = FactoryGirl.create(:film_with_dimensions, phase: "stock")
    with_versioning do
      Timecop.freeze(Time.zone.today - 2) do
        @film.update_attributes(destination: "wip")
      end
      @film.update_attributes(destination: "fg")
    end
  end
  
  describe "searching film movements between two days ago and yesterday" do
    let(:user) { FactoryGirl.create(:user) }
    
    before do
      log_in(user)
      click_link "History"
      click_link "Film movements"
      fill_in "Start", with: Time.zone.today - 2
      fill_in "End", with: Time.zone.today - 1
      click_button "Search"
    end

    it "displays searched movement" do
      skip "with_verioning doesn't work correctly, see paper_trail issue 312"
      assert page.has_selector?("tr", text: @film.serial, count: 1)
    end
  end
end
