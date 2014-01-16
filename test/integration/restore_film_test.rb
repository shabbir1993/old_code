require 'test_helper'

class RestoreFilmTest < ActionDispatch::IntegrationTest

  let(:supervisor) { FactoryGirl.create(:supervisor) }
  let(:admin) { FactoryGirl.create(:admin) }

  before do 
    @deleted_film = FactoryGirl.create(:film, deleted: true)
  end

  describe "deleted films tab with admin authentication" do
    before do
      use_javascript_driver
      log_in(admin)
      click_link "Production"
      click_link "Deleted"
    end

    it "have working restore links" do
      click_link "film-#{@deleted_film.id}-restore"
      assert page.has_selector?("#film-#{@deleted_film.id}", text: "#{@deleted_film.phase}")
    end
  end

  it "has no deleted tab with supervisor authentication" do
    log_in(supervisor)
    click_link "Production"
    refute page.has_link?("Deleted")
  end
end

