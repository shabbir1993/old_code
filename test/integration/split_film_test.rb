require 'test_helper'

class SplitFilmTest < ActionDispatch::IntegrationTest

  before do
    use_javascript_driver
    @film = FactoryGirl.create(:film, phase: "stock")
  end

  describe "split button" do
    let(:user) { FactoryGirl.create(:user) }

    before do 
      log_in(user)
      click_link "Production"
      click_link "Available"
      click_link "film-#{@film.id}-split"
    end
    
    it "creates a new split" do
      save_screenshot("ss.png")
      assert page.has_content?("#{@film.serial.next}")
    end
  end
end
