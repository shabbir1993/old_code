require 'test_helper'

describe "History integration" do
  before do 
    Capybara.current_driver = Capybara.javascript_driver
    http_login
    click_link "History"
  end

  it "has the right title" do
      page.has_title?("History").must_equal true
  end

  describe "film movements history" do
    before do
      click_link "Film movements"
    end

    it "contains the correct table" do
      assert page.has_selector?("table.film-movements-history")
    end

    it "records the movement of films created" do
      visit films_path(scope: "lamination")
      attrs = FactoryGirl.attributes_for(:master_film)
      click_link 'Enter film'
      fill_in 'Serial', with: attrs[:serial]
      click_button 'Add film'
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

  describe "fg film movements history page" do
    it "contains the correct table" do
      click_link 'FG movements'
      assert page.has_selector?("table.fg-film-movements-history")
    end
  end

  describe "scrap movement history page" do
    it "contains the correct table" do
      click_link 'Scrap movements'
      assert page.has_selector?("table.scrap-film-movements-history")
    end
  end

  describe "reserved checkouts history page" do
    it "contains the correct table" do
      click_link 'Reserved checkouts'
      assert page.has_selector?("table.reserved-checkouts-history")
    end
  end

  describe "phase snapshot history page" do
    it "contains the correct table" do
      click_link 'Phase snapshots'
      page.has_selector?("table.phase-snapshots-history").must_equal true
    end
  end
end
