require 'test_helper'

describe "Restore deleted film integration" do
  let(:supervisor) { FactoryGirl.create(:supervisor, tenant: @tenant) }
  let(:admin) { FactoryGirl.create(:admin, tenant: @tenant) }

  before do 
    @tenant = FactoryGirl.create(:tenant)
    @deleted_film = FactoryGirl.create(:film, deleted: true, tenant: @tenant)
  end

  describe "deleted films with admin authentication" do
    before do
      Capybara.current_driver = Capybara.javascript_driver
      log_in(admin)
      click_link "Production"
      click_link "Deleted"
    end

    it "have working restore links" do
      click_link "film-#{@deleted_film.id}-restore"
      assert page.has_selector?('td', text: "#{@deleted_film.serial} #{@deleted_film.phase}")
    end
  end

  it "has no deleted tab with supervisor authentication" do
    log_in(supervisor)
    click_link "Production"
    refute page.has_link?('a', text: "Deleted")
  end
end

