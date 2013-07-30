require 'test_helper'

describe "Inventory integration" do
  before do 
    Capybara.current_driver = Capybara.javascript_driver
    http_login
    visit films_path(scope: "lamination")
  end

  it "has the right title" do
    page.has_title?("Inventory").must_equal true
  end

  describe "lamination tab" do
    before { click_link 'Lamination' }

    it "creates a new film given valid attributes" do
      machine = FactoryGirl.create(:machine)
      chemist = FactoryGirl.create(:chemist)
      operator = FactoryGirl.create(:operator)
      attrs = FactoryGirl.attributes_for(:master_film)
      click_link 'Enter film'
      fill_in 'Serial', with: attrs[:serial]
      fill_in 'Formula', with: attrs[:formula]
      fill_in 'Mix mass', with: attrs[:mix_mass]
      select machine.code, from: 'Machine'
      fill_in 'Film code', with: attrs[:film_code]
      fill_in 'Thinky code', with: attrs[:thinky_code]
      select chemist.name, from: 'Chemist'
      select operator.name, from: 'Operator'
      click_button 'Add film'
      page.has_selector?('td.serial', text: attrs[:serial]).must_equal true
      page.has_selector?('td.formula', text: attrs[:formula]).must_equal true
      page.has_selector?('td.mix_mass', text: attrs[:mix_mass]).must_equal true
      page.has_selector?('td.machine_code', text: machine.code).must_equal true
      page.has_selector?('td.film_code', text: attrs[:film_code]).must_equal true
      page.has_selector?('td.thinky_code', text: attrs[:thinky_code]).must_equal true
      page.has_selector?('td.chemist_name', text: chemist.name).must_equal true
      page.has_selector?('td.operator_name', text: operator.name).must_equal true
    end

    it "displays error messages given invalid attributes" do
      click_link 'Enter film'
      click_button 'Add film'
      assert page.has_selector?('.help-inline', text: "can't be blank").must_equal true
    end

    describe "pagination" do
      before do 
        30.times { FactoryGirl.create(:film) }
        click_link 'Lamination'
      end

      it "displays users on first page" do
        page.has_selector?('tbody tr', count: 25).must_equal true
      end

      it "displays users on second page" do
        within('.pagination') do
          click_link '2'
        end
        page.has_selector?('tbody tr', count: 5).must_equal true
      end
    end
  end

  describe "inspection tab with one film" do
    before do
      @inspection_film = FactoryGirl.create(:film, phase: "inspection")
      click_link 'Inspection'
    end 

    describe "edit form" do
      before do
        within('tr', text: @inspection_film.serial) do
          click_link 'Edit'
        end
      end

      it "displays correct movement fields on destination selection" do
        select 'stock', from: 'Move to'
        page.has_selector?('#backend-destination-fields', visible: true).must_equal true
        select 'wip', from: 'Move to'
        page.has_selector?('#backend-destination-fields', visible: false).must_equal true
        page.has_selector?('#checkout-destination-fields', visible: true).must_equal true
      end
      
      it "updates fields and moves film to stock given valid attributes" do
        fill_in 'film_effective_width', with: 60
        fill_in 'film_effective_length', with: 70
        select 'stock', from: 'Move to'
        fill_in 'Shelf', with: "M1"
        fill_in 'Reserved for', with: "Example company"
        fill_in 'Note', with: "Example note"
        click_button 'Update'
        page.has_selector?('tbody td', text: @inspection_film.serial).must_equal false
        click_link 'Stock'
        within "tbody", text: @inspection_film.serial do
          page.has_selector?('td.width', text: "60").must_equal true
          page.has_selector?('td.length', text: "70").must_equal true
          page.has_selector?('td.shelf', text: "M1").must_equal true
          page.has_selector?('td.reserved_for', text: "Example company").must_equal true
          page.has_selector?('td.note', text: "Example note").must_equal true
        end
      end

      it "adds defects given valid attributes" do
        click_link "Add defect"
        select 'White Spot', from: 'Defect type'
        fill_in 'Count', with: 3
        click_button 'Update'
        within('tr', text: @inspection_film.serial) do
          assert page.has_selector?('td.defect_count', text: '3')
        end
      end

      it "displays error messages given invalid defect attributes" do
        click_link "Add defect"
        click_button 'Update'
        page.has_selector?('.help-inline', text: "can't be blank").must_equal true
      end
    end

    describe "edit form with defects" do
      before do
        FactoryGirl.create(:defect, count: 1, master_film: @inspection_film.master_film)
        FactoryGirl.create(:defect, count: 1, master_film: @inspection_film.master_film)
        within('tr', text: @inspection_film.serial) do
          click_link 'Edit'
        end
      end

      it "remove button removes defect" do
        click_link('remove', match: :first)
        click_button 'Update'
        save_screenshot('ss.png', full: true)
        within('tr', text: @inspection_film.serial) do
          assert page.has_selector?('td.defect_count', text: '1')
        end
      end
    end
  end

  describe "stock tab with multiple films" do
    before do
      @stock_film_1 = FactoryGirl.create(:film, phase: "stock", width: 60, length: 60) 
      @stock_film_2 = FactoryGirl.create(:film, phase: "stock", width: 60, length: 60) 
      @stock_film_3 = FactoryGirl.create(:film, phase: "stock", width: 60, length: 60) 
      click_link 'Stock'
    end

    it "displays the correct number of films" do
      page.has_selector?('tbody tr', count: 3).must_equal true
    end

    it "displays the count" do
      page.has_selector?('.summary .count', text: '3').must_equal true
    end

    it "displays the total sqft" do
      page.has_selector?('.summary .total-sqft', text: '75').must_equal true
    end

    it "displays the films in the correct order" do
      within('tbody') do
        assert_operator page.all('.serial')[0].text, :>, page.all('.serial')[1].text
        assert_operator page.all('.serial')[1].text, :>, page.all('.serial')[2].text
      end
    end

    describe "split form" do
      before do
        within('tr', text: @stock_film_1.serial) do
          click_link "Split"
        end
      end
    
      it "splits film" do
        within('div.original-film') do
          fill_in 'Width', with: 50
          fill_in 'Length', with: 51
        end
        fill_in 'film_master_film_attributes_films_attributes_1_width', with: 52
        fill_in 'film_master_film_attributes_films_attributes_1_length', with: 53
        fill_in 'film_master_film_attributes_films_attributes_2_width', with: 54
        fill_in 'film_master_film_attributes_films_attributes_2_length', with: 55
        click_button "Split"
        assert page.has_selector?('tr', text: @stock_film_1.master_film.serial, count: 3)
        assert page.has_selector?('td.width', text: 50)
        assert page.has_selector?('td.length', text: 51)
        assert page.has_selector?('td.width', text: 52)
        assert page.has_selector?('td.length', text: 53)
        assert page.has_selector?('td.width', text: 54)
        assert page.has_selector?('td.length', text: 55)
      end
    end

    describe "with multiple films checked" do
      before do
        within('tr', text: @stock_film_1.serial) { check 'film_ids_' }
        within('tr', text: @stock_film_2.serial) { check 'film_ids_' }
      end

      it "moves them to wip given destination" do
        click_button 'Move selected'
        select 'wip', from: 'Move to'
        click_button 'Move all'
        sleep 1
        page.has_selector?('tbody tr', text: @stock_film_1.serial).must_equal false
        page.has_selector?('tbody tr', text: @stock_film_2.serial).must_equal false
        click_link 'WIP'
        page.has_selector?('tbody tr', text: @stock_film_1.serial).must_equal true
        page.has_selector?('tbody tr', text: @stock_film_2.serial).must_equal true
      end

      it "does not move them to wip given no destination" do
        click_button 'Move selected'
        click_button 'Move all'
        page.has_selector?('tbody tr', text: @stock_film_1.serial).must_equal true
        page.has_selector?('tbody tr', text: @stock_film_1.serial).must_equal true
      end
    end
  end
end
