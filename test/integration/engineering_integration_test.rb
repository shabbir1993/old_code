require 'test_helper'

describe "Engineering integration" do
  let(:user) { FactoryGirl.create(:user) }

  before do 
    Capybara.current_driver = Capybara.javascript_driver
    @master_film = FactoryGirl.create(:master_film_with_child)
    log_in(user)
    click_link "Engineering"
  end

  it "has the right title" do
    page.has_title?("Engineering").must_equal true
  end

  it "lists master films" do
    3.times { FactoryGirl.create(:master_film_with_child) }
    click_link "Engineering"
    MasterFilm.all.each do |master_film|
      page.has_selector?('td.serial', text: master_film.serial).must_equal true
    end
  end

  describe "with supervisor authentication" do
    let(:supervisor) {FactoryGirl.create(:supervisor) }
    before do
      log_in(supervisor)
      click_link "Engineering"
    end

    it "creates a new master film given valid attributes" do
      machine = FactoryGirl.create(:machine)
      chemist = FactoryGirl.create(:chemist)
      operator = FactoryGirl.create(:operator)
      save_screenshot('ss.png')
      click_link 'Enter film'
      fill_in 'Serial', with: "F1223-12"
      fill_in 'Formula', with: "HA"
      fill_in 'Mix mass', with: 101.1
      select machine.code, from: 'Machine'
      fill_in 'Film code', with: "1234"
      fill_in 'Thinky code', with: "1"
      select chemist.full_name, from: 'Chemist'
      select operator.full_name, from: 'Operator'
      click_button 'Add film'
      within("tr.success") do
        page.has_selector?('td.serial', text: "F1223-12").must_equal true
        page.has_selector?('td.formula', text: "HA").must_equal true
        page.has_selector?('td.mix_mass', text: "101.1").must_equal true
        page.has_selector?('td.machine_code', text: machine.code).must_equal true
        page.has_selector?('td.film_code', text: "1234").must_equal true
        page.has_selector?('td.thinky_code', text: "1").must_equal true
        page.has_selector?('td.chemist', text: chemist.full_name).must_equal true
        page.has_selector?('td.operator', text: operator.full_name).must_equal true
      end
    end

    it "displays error messages given invalid attributes" do
      click_link 'Enter film'
      click_button 'Add film'
      page.has_selector?('.error-messages', text: "can't be blank").must_equal true
    end
  end

  describe "edit form" do
    before { click_link "masterfilm-#{@master_film.id}-edit" }

    it "updates master film attributes" do
      fill_in "Formula", with: "TT"
      click_button 'Update'
      within('tr.info', text: @master_film.serial) do
        page.has_selector?('td.formula', text: "TT")
      end
    end

    it "adds defects given valid attributes" do
      click_link "Add defect"
      select 'White Spot', from: 'Type'
      fill_in 'Count', with: 3
      click_button 'Update'
      within('tr.info', text: @master_film.serial) do
        assert page.has_selector?('td.defect_count', text: '3')
      end
    end

    it "displays error messages given invalid defect attributes" do
      click_link "Add defect"
      click_button 'Update'
      page.has_selector?('.error-messages', text: "can't be blank").must_equal true
    end
  end

  describe "edit form with a defect" do
    before do
      FactoryGirl.create(:defect, count: 1, master_film: @master_film)
      click_link "masterfilm-#{@master_film.id}-edit"
    end

    it "displays existing defect fields" do
      page.has_selector?('fieldset.defect-fields').must_equal true
    end

    it "remove button removes defect" do
      click_link('remove', match: :first)
      page.has_selector?('fieldset.defect-fields').must_equal false
      click_button 'Update'
      within('tr.info', text: @master_film.serial) do
        assert page.has_selector?('td.defect_count', text: '0')
      end
    end
  end
end
