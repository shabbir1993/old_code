require 'test_helper'

describe "Film split integration" do
  before do
    Capybara.current_driver = Capybara.javascript_driver
    @tenant = FactoryGirl.create(:tenant)
    @film = FactoryGirl.create(:film, phase: "stock", tenant: @tenant)
  end

  describe "split form with supervisor authentication" do
    let(:supervisor) { FactoryGirl.create(:supervisor, tenant: @tenant) }

    before do 
      log_in(supervisor)
      click_link "Production"
      click_link "Available"
      click_link "film-#{@film.id}-split" 
    end
    
    it "splits updates and moves film given valid attributes" do
      within ".original-fields" do
        fill_in 'Note', with: "Split happens"
      end
      within ".split-fields" do
        select "wip", from: "film_split_destination"
      end
      click_button 'Split'
      page.has_selector?("#film-#{@film.id} .note", text: "Split happens").must_equal true
      page.has_selector?("tr", text: "#{@film.serial.next} wip").must_equal true
    end

    it "shows error messages given invalid inputs" do
      within ".original-fields" do
        fill_in 'film_order_fill_count', with: ""
      end
      within ".split-fields" do
        fill_in 'film_split_order_fill_count', with: ""
      end
      click_button 'Split'
      page.has_selector?('.original-fields .error-messages').must_equal true
      page.has_selector?('.split-fields .error-messages').must_equal true
    end
  end
end
