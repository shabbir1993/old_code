require 'test_helper'

describe "Master film edit integration" do
  before do 
    Capybara.current_driver = Capybara.javascript_driver
    @tenant = FactoryGirl.create(:tenant)
    @master_film = FactoryGirl.create(:master_film_with_child, tenant: @tenant)
    @defect = FactoryGirl.create(:defect, master_film: @master_film)
  end

  describe "edit form with supervisor authentication" do
    let(:supervisor) { FactoryGirl.create(:supervisor, tenant: @tenant) }

    before do
      log_in(supervisor)
      click_link "Engineering"
      click_link "masterfilm-#{@master_film.id}-edit"
    end

    it "updates master film and defect attributes" do
      fill_in "Note", with: "New note"
      click_link 'remove'
      click_link "Add defect"
      select 'White Spot', from: 'Type'
      fill_in 'Count', with: 1
      click_button 'Update'
      within("#master-film-#{@master_film.id}", text: @master_film.serial) do
        page.has_selector?('td.note', text: "New note").must_equal true
        page.has_selector?('td.defects_sum', text: '1').must_equal true
      end
    end

    it "displays error messages given invalid defect attributes" do
      click_link "Add defect"
      click_button 'Update'
      page.has_selector?('.error-messages', text: "can't be blank").must_equal true
    end

    it "does not have a serial field" do
      page.has_selector?('input#master_film_serial').must_equal false
    end
  end

  describe "edit form with admin authentication" do
    let(:admin) { FactoryGirl.create(:admin, tenant: @tenant) }

    before do
      log_in(admin)
      click_link "Engineering"
      click_link "masterfilm-#{@master_film.id}-edit"
    end

    it "has a serial field" do
      page.has_selector?('input#master_film_serial').must_equal true
    end
  end
end
