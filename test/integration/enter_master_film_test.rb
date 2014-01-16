require 'test_helper'

class EnterMasterFilmTest < ActionDispatch::IntegrationTest

  before { use_javascript_driver }

  describe "Film entry form with supervisor authentication" do
    let(:supervisor) { FactoryGirl.create(:supervisor) }

    before do
      log_in(supervisor)
      click_link "Engineering"
      click_link 'Enter film'
    end

    it "creates a new master film with defects given valid attributes" do
      fill_in 'Serial', with: "F1223-12"
      click_link "Add defect"
      select 'White Spot', from: 'master_film_defects_key'
      fill_in 'Count', with: 2
      click_button 'Add film'
      within("tr.success") do
        assert page.has_selector?('.serial', text: "F1223-12")
        assert page.has_selector?('.defects_sum', text: '2')
      end
    end

    it "displays error messages given invalid attributes" do
      click_button 'Add film'
      assert page.has_selector?('.error-messages')
    end
  end
end
