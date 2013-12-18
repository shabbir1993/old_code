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
        assert page.has_selector?('td.note', text: "New note")
        assert page.has_selector?('td.defects_sum', text: '1')
      end
    end

    it "displays error messages given invalid defect attributes" do
      click_link "Add defect"
      click_button 'Update'
      assert page.has_selector?('.error-messages', text: "can't be blank")
    end
  end
end
