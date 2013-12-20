require 'test_helper'

describe "Production integration" do
  before do
    Capybara.current_driver = Capybara.javascript_driver
  end

  describe "with user authentication" do
    let(:user) { FactoryGirl.create(:user) }
    before do 
      log_in(user)
      click_link "Production"
    end

    describe "inspection tab with one film" do
      before do
        @inspection_film = FactoryGirl.create(:film, phase: "inspection")
        click_link 'Inspection'
      end 

      describe "edit form" do
        before { click_link "film-#{@inspection_film.id}-edit" }

        it "does not display movement fields" do
          page.has_selector?("#film_destination").must_equal false
        end
        
        it "updates fields given valid attributes" do
          fill_in 'film_effective_width', with: 60
          fill_in 'film_effective_length', with: 70
          fill_in 'Note', with: "Lorem Ipsum"
          click_button 'Update'
          within "tbody", text: @inspection_film.serial do
            page.has_selector?('td.effective_width', text: "60").must_equal true
            page.has_selector?('td.effective_length', text: "70").must_equal true
            page.has_selector?('td.note', text: "Lorem Ipsum").must_equal true
          end
        end

        it "does not have a delete checkbox" do
          page.has_selector?("#film_deleted").must_equal false
        end
      end
    end

    describe "<16 stock tab with multiple films" do
      before do
        @small_film_1 = FactoryGirl.create(:film, phase: "stock", width: 30, length: 30, shelf: "A5")
        @small_film_2 = FactoryGirl.create(:film, phase: "stock", width: 20, length: 40, shelf: "B0")
        @small_film_3 = FactoryGirl.create(:film, phase: "stock", width: 10, length: 50, shelf: "A5")
        click_link '<16'
      end

      it "displays the correct number of films" do
        page.has_selector?('tbody tr', count: 3).must_equal true
      end

      describe "edit multiple form" do
        before do
          within('tr', text: @small_film_1.serial) { check 'film_ids_' }
          within('tr', text: @small_film_2.serial) { check 'film_ids_' }
          click_button 'Move selected'
        end

        it "does not display movement fields" do
          page.has_selector?("#film_destination").must_equal false
        end
      end

      describe "searching" do
        before do
          fill_in "Search", with: "A5"
          fill_in "min-width", with: 20
          fill_in "max-width", with: 35
          fill_in "min-length", with: 25
          fill_in "max-length", with: 40
          click_button "Search"
        end

        it "retains the search inputs" do
          find_field('query').value.must_equal "A5"
          find_field('min-width').value.must_equal "20"
          find_field('max-width').value.must_equal "35"
          find_field('min-length').value.must_equal "25"
          find_field('max-length').value.must_equal "40"
        end

        it "displays the searched films" do
          page.has_selector?('td.serial', text: @small_film_1.serial).must_equal true
        end

        it "displays the searched films ordered by width/length"

        it "does not display other films" do
          page.has_selector?('td.serial', text: @small_film_2.serial).must_equal false
          page.has_selector?('td.serial', text: @small_film_3.serial).must_equal false
        end
      end
    end

    describe "reserved stock tab" do
      before do
        @sales_order = FactoryGirl.create(:sales_order)
        @reserved_film = FactoryGirl.create(:film, phase: "stock", width: 72, 
                                            length: 110, sales_order: @sales_order)
        click_link "Reserved"
      end

      describe "split form" do
        before { click_link "film-#{@reserved_film.id}-split" }
      
        it "splits film and displays in correct order" do
          within('.original-fields') do
            fill_in 'Width', with: 30
            fill_in 'Length', with: 35
          end
          within('.split-fields') do
            fill_in 'Width', with: 25
            fill_in 'Length', with: 40
          end
          click_button "Split"
          within('tr.info') do
            page.has_selector?('td.serial', text: @reserved_film.serial).must_equal true
            page.has_selector?('td.width', text: 30).must_equal true
            page.has_selector?('td.length', text: 35).must_equal true
          end
          within('tr.success', text: "#{@reserved_film.master_film.serial}-2") do
            page.has_selector?('td.width', text: 25).must_equal true
            page.has_selector?('td.length', text: 40).must_equal true
          end
        end
      end
    end

    it "does not have a deleted tab" do
      page.has_selector?('div.sidebar-fixed a', text: "Deleted").must_equal false
    end
  end

  describe "with supervisor authentication" do
    let(:supervisor) { FactoryGirl.create(:supervisor) }
    before do 
      log_in(supervisor)
      click_link "Production"
    end

    describe "fg tab with one film" do
      before do
        @fg_film = FactoryGirl.create(:film, phase: "fg")
        click_link 'FG'
      end 

      describe "edit form" do
        before { click_link "film-#{@fg_film.id}-edit" }

        it "displays correct movement fields on destination selection" do
          select 'nc', from: 'film_destination'
          page.has_selector?('.shelf-fields', visible: true).must_equal true
          select 'wip', from: 'film_destination'
          page.has_selector?('.line-item-fields', visible: false).must_equal true
        end
        
        it "updates fields and moves film to stock given valid attributes" do
          select 'nc', from: 'film_destination'
          fill_in 'Shelf', with: "M1"
          fill_in 'Note', with: "Example note"
          click_button 'Update'
          page.has_selector?('tr.alert-info', text: "#{@fg_film.serial} nc").must_equal true
          click_link 'NC'
          within "#film-#{@fg_film.id}" do
            page.has_selector?('td.shelf', text: "M1").must_equal true
            page.has_selector?('td.note', text: "Example note").must_equal true
          end
        end
      end
    end

    describe "available tab with multiple films" do
      before do
        @available_film_1 = FactoryGirl.create(:film, phase: "stock", width: 60, length: 60) 
        @available_film_2 = FactoryGirl.create(:film, phase: "stock", width: 40, length: 72) 
        @available_film_3 = FactoryGirl.create(:film, phase: "stock", width: 36, length: 100) 
        @sales_order = FactoryGirl.create :sales_order
        click_link 'Available'
      end

      it "disables edit multiple button when less than 2 films are selected" do
        page.has_selector?("#film-edit-multiple[disabled]").must_equal true
      end

      describe "edit multiple" do
        before do
          within('tr', text: @available_film_1.serial) { check 'film_ids_' }
          within('tr', text: @available_film_2.serial) { check 'film_ids_' }
          click_button 'Move selected'
        end

        it "updates and moves multiple films" do
          select 'wip', from: 'film_destination'
          select @sales_order.code, from: 'film_sales_order_id'
          click_button 'Move all'
          page.has_selector?('tr.alert-info', text: "#{@available_film_1.serial} wip").must_equal true
          page.has_selector?('tr.alert-info', text: "#{@available_film_2.serial} wip").must_equal true
          click_link 'WIP'
          within('tr', text: @available_film_1.serial) do
            page.has_selector?('td.line_item', text: @sales_order.code)
          end
          within('tr', text: @available_film_2.serial) do
            page.has_selector?('td.line_item', text: @sales_order.code)
          end
        end
      end
    end
  end
  
  describe "with admin authentication" do
    let(:admin) { FactoryGirl.create(:admin) }
    before do 
      log_in(admin)
      click_link "Production"
    end

    describe "stock edit form with one film" do
      before do
        @stock_film = FactoryGirl.create(:film, phase: "stock")
        click_link 'Available'
        click_link "film-#{@stock_film.id}-edit"
      end 

      it "has a working delete checkbox" do
        check("Delete")
        click_button "Update"
        page.has_selector?('tr.alert-info', text: "#{@stock_film.serial} deleted").must_equal true
        click_link 'Deleted'
        page.has_selector?('td.serial', text: @stock_film.serial)
      end
    end

    describe "deleted tab with deleted film" do
      before do
        @deleted_film = FactoryGirl.create(:film, deleted: true, phase: "stock")
        click_link "Deleted"
      end

      it "restores film" do
        click_link "film-#{@deleted_film.id}-restore"
        page.has_selector?('tr.alert-info', text: "#{@deleted_film.serial} stock").must_equal true
        click_link "Available"
        page.has_selector?('tr', text: @deleted_film.serial).must_equal true
      end
    end
  end
end
