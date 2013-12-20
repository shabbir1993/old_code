require 'test_helper'

describe "Film edit integration" do
  before do
    Capybara.current_driver = Capybara.javascript_driver
    @tenant = FactoryGirl.create(:tenant)
    @film = FactoryGirl.create(:film, phase: "lamination", tenant: @tenant)
  end

  describe "edit form with supervisor authentication" do
    let(:supervisor) { FactoryGirl.create(:supervisor, tenant: @tenant) }

    before do 
      log_in(supervisor)
      click_link "Production"
      click_link "film-#{@film.id}-edit" 
    end
    
    it "updates film given valid attributes" do
      fill_in 'Note', with: "New note"
      click_button 'Update'
      within "tr", text: @film.serial do
        page.has_selector?('.note', text: "New note").must_equal true
      end
    end

    it "moves film" do
      select 'inspection', from: 'film_destination'
      click_button 'Update'
      within "tr", text: @film.serial do
        page.has_content?("inspection").must_equal true
      end
    end

    it "displays error messages given invalid inputs" do
      skip "add when all films have the same edit form"
    end

    it "does not have a delete checkbox" do
      page.has_selector?('input#film_deleted').must_equal false
    end
  end

  describe "edit form with admin authentication" do
    let(:admin) { FactoryGirl.create(:admin, tenant: @tenant) }
    before do 
      log_in(admin)
      click_link "Production"
      click_link "film-#{@film.id}-edit" 
    end

    it "has a working delete checkbox" do
      check("Deleted")
      click_button "Update"
      within "tr", text: @film.serial do
        page.has_content?("deleted").must_equal true
      end
    end
  end
end
