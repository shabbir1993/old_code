require 'test_helper'

class SearchHistoryTest < ActionDispatch::IntegrationTest
  before do
    @film1 = FactoryGirl.create(:film_movement, created_at: 2.days.ago)
    @film2 = FactoryGirl.create(:film_movement, created_at: Time.zone.today)
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
      assert page.has_content?(@film1.serial)
    end

    it "filters other movements" do
      refute page.has_content?(@film2.serial)
    end
  end
end
