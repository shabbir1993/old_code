require 'test_helper'

describe "History integration" do
  before do 
    Capybara.current_driver = Capybara.javascript_driver
    http_login
  end

  describe "film movements history" do
    it "has the right title" do
      visit film_movements_history_path
      page.has_title?("History").must_equal true
    end

    it "records the movement of films created" do
      visit films_path(scope: "lamination")
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
      save_screenshot('ss.png', full: true)
      within '.navbar' do
        click_link "History" 
      end
      click_link "Film movements"
      within 'table.film-movements-history' do
        page.has_selector?('td.serial', text: attrs[:serial]).must_equal true
        page.has_selector?('td.from', text: "raw material").must_equal true
        page.has_selector?('td.to', text: "lamination").must_equal true
        page.has_selector?('td.area', text: "").must_equal true
      end
    end

    it "records the movement of films moved" do
      film = FactoryGirl.create(:film, phase: "stock", width: 60, length: 60)
      visit films_path(scope: "large_stock")
      within('tr', text: film.serial) do
        click_link 'Edit'
      end
      select 'wip', from: 'Move to'
      click_button "Update"
      within '.navbar' do
        click_link "History" 
      end
      click_link "Film movements"
      within 'table.film-movements-history' do
        page.has_selector?('td.serial', text: film.serial).must_equal true
        page.has_selector?('td.from', text: "stock").must_equal true
        page.has_selector?('td.to', text: "wip").must_equal true
        page.has_selector?('td.area', text: "25").must_equal true
      end
    end
    
    it "records the movement of bulk moved films" do
      stock_film_1 = FactoryGirl.create(:film, phase: "stock", width: 60, length: 60) 
      stock_film_2 = FactoryGirl.create(:film, phase: "stock", width: 60, length: 60) 
      visit films_path(scope: "large_stock")
      within('tr', text: stock_film_1.serial) { check 'film_ids_' }
      within('tr', text: stock_film_2.serial) { check 'film_ids_' }
      click_button 'Move selected'
      select 'wip', from: 'Move to'
      click_button 'Move all'
      sleep 1
      within '.navbar' do
        click_link "History" 
      end
      click_link "Film movements"
      within 'table.film-movements-history' do
        page.has_selector?('td.serial', text: stock_film_1.serial).must_equal true
        page.has_selector?('td.serial', text: stock_film_2.serial).must_equal true
        page.has_selector?('td.from', text: "stock", count: 2).must_equal true
        page.has_selector?('td.to', text: "wip", count: 2).must_equal true
        page.has_selector?('td.area', text: "25", count: 2).must_equal true
      end
    end
  end
  describe "fg film movements history" do
    it "has the right title" do
      visit fg_film_movements_history_path
      page.has_title?("History").must_equal true
    end
  end
end
