require 'test_helper'

class EditMasterFilmTest < ActionDispatch::IntegrationTest
  before do 
    use_javascript_driver
    @master_film = FactoryGirl.create(:master_film_with_child, defects: { "White Spot" => "2" })
  end

  describe "edit form" do
    let(:user) { FactoryGirl.create(:user) }

    before do
      log_in(user)
      click_link "Engineering"
      click_link "masterfilm-#{@master_film.id}-edit"
    end

    it "updates master film and defect attributes" do
      fill_in "Note", with: "New note"
      click_link 'remove'
      click_link "Add defect"
      select 'White Spot', from: 'master_film_defects_key'
      fill_in 'Count', with: 1
      click_button 'Update'
      within("#master-film-#{@master_film.id}") do
        assert page.has_selector?('.note', text: "New note")
        assert page.has_selector?('.defects_sum', text: '1')
      end
    end

    it "does not have a serial field" do
      refute page.has_selector?('input#master_film_serial')
    end
  end

  describe "edit form with admin authentication" do
    let(:admin) { FactoryGirl.create(:admin) }

    before do
      log_in(admin)
      click_link "Engineering"
      click_link "masterfilm-#{@master_film.id}-edit"
    end

    it "has a serial field" do
      assert page.has_selector?('input#master_film_serial')
    end

    it "displays error messages given invalid inputs" do
      fill_in "Serial", with: "invalid serial"
      click_button 'Update'
      assert page.has_selector?('.error-messages')
    end
  end
end
