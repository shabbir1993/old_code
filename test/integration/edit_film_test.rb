require 'test_helper'

class EditFilmTest < ActionDispatch::IntegrationTest
  before do
    use_javascript_driver
    @film = FactoryGirl.create(:film, phase: "lamination")
  end

  describe "edit form" do
    let(:user) { FactoryGirl.create(:user) }

    before do 
      log_in(user)
      click_link "Production"
      click_link "film-#{@film.id}-edit" 
    end
    
    it "updates film given valid attributes" do
      fill_in 'Note', with: "New note"
      click_button 'Update'
      assert page.has_selector?("#film-#{@film.id}", text: "New note")
    end

    it "moves film" do
      select 'inspection', from: 'film_destination'
      click_button 'Update'
      assert page.has_selector?("#film-#{@film.id}", text: "inspection")
    end

    it "displays error messages given invalid inputs" do
      fill_in 'Count', with: ""
      click_button 'Update'
      assert page.has_selector?('.error-messages')
    end

    it "does not have a delete checkbox" do
      refute page.has_selector?('form', text: "Deleted")
    end
  end

  describe "edit form with admin authentication" do
    let(:admin) { FactoryGirl.create(:admin) }

    before do 
      log_in(admin)
      click_link "Production"
      click_link "film-#{@film.id}-edit" 
    end

    it "has a working delete button" do
      sleep 0.1
      click_link "Delete"
      assert page.has_selector?("#film-#{@film.id}", text: "deleted")
    end
  end
end
