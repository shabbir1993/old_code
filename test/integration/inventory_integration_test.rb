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
      click_link 'Enter film'
      fill_in 'Serial', with: "F1223-12"
      fill_in 'Formula', with: "HA"
      fill_in 'Mix mass', with: 101.1
      select machine.code, from: 'Machine'
      fill_in 'Film code', with: "1234"
      fill_in 'Thinky code', with: "1"
      select chemist.name, from: 'Chemist'
      select operator.name, from: 'Operator'
      click_button 'Add film'
      within("tr.success") do
        page.has_selector?('td.serial', text: "F1223-12").must_equal true
        page.has_selector?('td.formula', text: "HA").must_equal true
        page.has_selector?('td.mix_mass', text: "101.1").must_equal true
        page.has_selector?('td.machine_code', text: machine.code).must_equal true
        page.has_selector?('td.film_code', text: "1234").must_equal true
        page.has_selector?('td.thinky_code', text: "1").must_equal true
        page.has_selector?('td.chemist_name', text: chemist.name).must_equal true
        page.has_selector?('td.operator_name', text: operator.name).must_equal true
      end
    end

    it "displays error messages given invalid attributes" do
      click_link 'Enter film'
      click_button 'Add film'
      page.has_selector?('.error-messages', text: "can't be blank").must_equal true
    end

    describe "pagination" do
      before do 
        30.times { FactoryGirl.create(:film) }
        click_link 'Lamination'
      end

      it "displays correct films on first page" do
        Film.lamination.page(1).each do |film|
          assert page.has_selector?('td.serial', text: film.serial)
        end
      end

      it "displays correct films on second page" do
        within('.pagination') { click_link '2' }
        Film.lamination.page(2).each do |film|
          assert page.has_selector?('td.serial', text: film.serial)
        end
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
        page.has_selector?('tr.info', text: "#{@inspection_film.serial} has been moved to stock").must_equal true
        click_link 'Stock'
        within "tbody", text: @inspection_film.serial do
          page.has_selector?('td.width', text: "60").must_equal true
          page.has_selector?('td.length', text: "70").must_equal true
          page.has_selector?('td.shelf', text: "M1").must_equal true
          page.has_selector?('td.reserved_for', text: "Example company").must_equal true
          page.has_selector?('td.note', text: "Example note").must_equal true
        end
      end

      it "has a working delete checkbox" do
        check("Delete")
        click_button "Update"
        page.has_selector?('tr.info', text: "#{@inspection_film.serial} has been deleted").must_equal true
        click_link 'Deleted'
        page.has_selector?('td.serial', text: @inspection_film.serial)
      end

      it "adds defects given valid attributes" do
        click_link "Add defect"
        select 'White Spot', from: 'Defect'
        fill_in 'Count', with: 3
        click_button 'Update'
        within('tr.info', text: @inspection_film.serial) do
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
        FactoryGirl.create(:defect, count: 1, master_film: @inspection_film.master_film)
        within('tr', text: @inspection_film.serial) do
          click_link 'Edit'
        end
      end

      it "remove button removes defect" do
        click_link('remove', match: :first)
        page.has_selector?('fieldset.defect_fields').must_equal false
        click_button 'Update'
        within('tr', text: @inspection_film.serial) do
          assert page.has_selector?('td.defect_count', text: '0')
        end
      end
    end
  end

  describe "stock tab with multiple films" do
    before do
      @stock_film_1 = FactoryGirl.create(:film, phase: "stock", width: 60, length: 60) 
      @stock_film_2 = FactoryGirl.create(:film, phase: "stock", width: 40, length: 72) 
      @stock_film_3 = FactoryGirl.create(:film, master_film: @stock_film_2.master_film, phase: "stock", width: 36, length: 100) 
      click_link 'Stock'
    end

    it "displays the correct number of films" do
      page.has_selector?('tbody tr', count: 3).must_equal true
    end

    it "displays the count" do
      page.has_selector?('.summary .count', text: '3').must_equal true
    end

    it "displays the total sqft" do
      page.has_selector?('.summary .total-sqft', text: '70').must_equal true
    end

    describe "searching for width between 40 and 60, length between 60 and 80" do
      before do
        fill_in "min-width", with: 40
        fill_in "max-width", with: 60
        fill_in "min-length", with: 60
        fill_in "max-length", with: 80
        click_button "Search"
      end

      it "retains the search inputs" do
        find_field('min-width').value.must_equal "40"
        find_field('max-width').value.must_equal "60"
        find_field('min-length').value.must_equal "60"
        find_field('max-length').value.must_equal "80"
      end

      it "displays films 1 and 2" do
        assert page.has_selector?('td.serial', text: @stock_film_1.serial)
        assert page.has_selector?('td.serial', text: @stock_film_2.serial)
      end

      it "does not display film 3" do
        page.has_selector?('td.serial', text: @stock_film_3.serial).must_equal false
      end
    end

    describe "split form" do
      before do
        within('tr', text: @stock_film_1.serial) do
          click_link "Split"
        end
      end
    
      it "splits film and displays in correct order" do
        #to simulate actual use, so original doesn't get ajax added
        sleep 2
        within('div.original-film') do
          fill_in 'Width', with: 50
          fill_in 'Length', with: 51
        end
        fill_in 'film_master_film_attributes_films_attributes_1_width', with: 52
        fill_in 'film_master_film_attributes_films_attributes_1_length', with: 53
        fill_in 'film_master_film_attributes_films_attributes_2_width', with: 54
        fill_in 'film_master_film_attributes_films_attributes_2_length', with: 55
        click_button "Split"
        within('tr.info') do
          assert page.has_selector?('td.serial', text: @stock_film_1.serial)
          assert page.has_selector?('td.width', text: 50)
          assert page.has_selector?('td.length', text: 51)
        end
        assert page.has_selector?('tr.success .serial', text: @stock_film_1.master_film.serial, count: 2)
        assert page.has_selector?('tr.success .width', text: 52)
        assert page.has_selector?('tr.success .length', text: 53)
        assert page.has_selector?('tr.success .width', text: 54)
        assert page.has_selector?('tr.success .length', text: 55)
        assert_operator page.all('tr.success .serial')[0].text, :<, page.all('tr.success .serial')[1].text
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
        page.has_selector?('tr.info', text: "#{@stock_film_1.serial} has been moved to wip").must_equal true
        page.has_selector?('tr.info', text: "#{@stock_film_2.serial} has been moved to wip").must_equal true
        click_link 'WIP'
        page.has_selector?('tr td.serial', text: @stock_film_1.serial).must_equal true
        page.has_selector?('tr td.serial', text: @stock_film_2.serial).must_equal true
      end

      it "does not move them to wip given no destination" do
        click_button 'Move selected'
        click_button 'Move all'
        page.has_selector?('td.serial', text: @stock_film_1.serial).must_equal true
        page.has_selector?('td.serial', text: @stock_film_1.serial).must_equal true
      end
    end
  end

  describe "trash tab with deleted film" do
    before do
      @deleted_film = FactoryGirl.create(:film, deleted: true, phase: "stock")
      click_link "Deleted"
    end

    it "restores film" do
      within('tr', text: @deleted_film.serial) { click_link "Restore" }
      page.has_selector?('tr.info', text: "#{@deleted_film.serial} has been moved to stock").must_equal true
      click_link "Stock"
      page.has_selector?('tr', text: @deleted_film.serial).must_equal true
    end
  end
end
