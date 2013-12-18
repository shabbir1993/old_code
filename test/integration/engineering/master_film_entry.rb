require 'test_helper'

describe "Master film entry integration" do

  before do 
    Capybara.current_driver = Capybara.javascript_driver
    @tenant = FactoryGirl.create(:tenant)
    @machine = FactoryGirl.create(:machine, tenant: @tenant)
    @chemist = FactoryGirl.create(:chemist, tenant: @tenant)
    @operator = FactoryGirl.create(:operator, tenant: @tenant)
  end

  describe "Film entry form with supervisor authentication" do
    let(:supervisor) { FactoryGirl.create(:supervisor, tenant: @tenant) }

    before do
      log_in(supervisor)
      click_link "Engineering"
      click_link 'Enter film'
    end

    it "creates a new master film with defects given valid attributes" do
      fill_in 'Serial', with: "F1223-12"
      click_link "Add defect"
      select 'White Spot', from: 'Type'
      fill_in 'Count', with: 2
      click_button 'Add film'
      within("tr") do
        assert page.has_selector?('td.serial', text: "F1223-12")
        assert page.has_selector?('td.defects_sum', text: '2')
      end
    end

    it "displays error messages given invalid attributes" do
      click_button 'Add film'
      assert page.has_selector?('.error-messages', text: "can't be blank")
    end
  end
end
