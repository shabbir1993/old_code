require 'test_helper'

describe "Engineering integration" do
  before do 
    Capybara.current_driver = Capybara.javascript_driver
    @master_film = FactoryGirl.create(:master_film)
    FactoryGirl.create(:master_film)
    http_login
    click_link "Engineering"
  end

  it "has the right title" do
    page.has_title?("Engineering").must_equal true
  end

  it "lists master films" do
    MasterFilm.all.each do |master_film|
      page.has_selector?('td.serial', text: master_film.serial).must_equal true
    end
  end

  describe "edit form" do
    before do
      within('tr', text: @master_film.serial) do
        click_link 'Edit'
      end
    end

    it "updates master film attributes" do
      fill_in "Formula", with: "TT"
      click_button 'Update'
      within('tr.info', text: @master_film.serial) do
        page.has_selector?('td.formula', text: "TT")
      end
    end

    it "adds defects given valid attributes" do
      click_link "Add defect"
      select 'White Spot', from: 'Defect'
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
      within('tr', text: @master_film.serial) do
        click_link 'Edit'
      end
    end

    it "remove button removes defect" do
      click_link('remove', match: :first)
      page.has_selector?('fieldset.defect_fields').must_equal false
      click_button 'Update'
      within('tr', text: @master_film.serial) do
        assert page.has_selector?('td.defect_count', text: '0')
      end
    end
  end
end
