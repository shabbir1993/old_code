require 'test_helper'

class SortFilmsTest < ActionDispatch::IntegrationTest
  before do
    @film1 = FactoryGirl.create(:film, shelf: "A1", phase: "inspection")
    @film2 = FactoryGirl.create(:film, shelf: "B1", phase: "inspection")
  end

  describe "inspection tab" do
    let(:user) { FactoryGirl.create(:user) }

    before do
      log_in(user)
      click_link "Production"
      click_link "Inspection"
    end

    it "sorts films based on shelf" do
      assert page.has_selector?("tbody tr:first-child", text: @film2.serial)
      click_link "Shelf"
      assert page.has_selector?("tbody tr:first-child", text: @film1.serial)
    end
  end
end
