require 'test_helper'

describe "Master film entry integration" do
  let(:tenant) { FactoryGirl.create :tenant }
  before do 
    Capybara.current_driver = Capybara.javascript_driver
    @machine = FactoryGirl.create(:machine, tenant: tenant)
    @chemist = FactoryGirl.create(:chemist, tenant: tenant)
    @operator = FactoryGirl.create(:operator, tenant: tenant)
  end

  describe "with supervisor authentication" do
    let(:supervisor) { FactoryGirl.create(:supervisor, tenant: tenant) }

    before do
      log_in(supervisor)
      click_link "Engineering"
      click_link 'Enter film'
    end

    it "creates a new master film given valid attributes" do
      fill_in 'Serial', with: "F1223-12"
      fill_in 'Width', with: 70
      fill_in 'Length', with: 110
      fill_in 'Formula', with: "HA"
      fill_in 'Mix mass', with: 101.1
      select @machine.code, from: 'Machine'
      fill_in 'Film code', with: "1234"
      fill_in 'Thinky code', with: "1"
      select @chemist.full_name, from: 'Chemist'
      select @operator.full_name, from: 'Operator'
      fill_in 'Note', with: "New film"
      click_link "Add defect"
      select 'White Spot', from: 'Type'
      fill_in 'Count', with: 3
      click_button 'Add film'
      within("tr.success") do
        assert page.has_selector?('td.serial', text: "F1223-12")
        assert page.has_selector?('td.effective_width', text: "70")
        assert page.has_selector?('td.effective_length', text: "110")
        assert page.has_selector?('td.formula', text: "HA")
        assert page.has_selector?('td.mix_mass', text: "101.1")
        assert page.has_selector?('td.machine_code', text: @machine.code)
        assert page.has_selector?('td.film_code', text: "1234")
        assert page.has_selector?('td.thinky_code', text: "1")
        assert page.has_selector?('td.chemist', text: @chemist.full_name)
        assert page.has_selector?('td.operator', text: @operator.full_name)
        assert page.has_selector?('td.note', text: "New film")
        assert page.has_selector?('td.defects_sum', text: '3')
      end
    end

    it "displays error messages given invalid attributes" do
      click_button 'Add film'
      page.has_selector?('.error-messages', text: "can't be blank").must_equal true
    end
  end
end
