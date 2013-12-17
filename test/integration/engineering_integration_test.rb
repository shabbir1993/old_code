require 'test_helper'

describe "Engineering integration" do
  let(:user) { FactoryGirl.create(:user) }
  let(:supervisor) {FactoryGirl.create(:supervisor) }

  before do 
    Capybara.current_driver = Capybara.javascript_driver
    @master_film = FactoryGirl.create(:master_film_with_child)
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
        assert page.has_selector?('td.defects_sum', text: '3')
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
        assert page.has_selector?('td.defects_sum', text: '0')
      end
    end
  end
end
