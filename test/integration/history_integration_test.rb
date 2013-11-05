require 'test_helper'

describe "History integration" do
  before do 
    @user = FactoryGirl.create(:user)
    log_in(@user)
    click_link "History"
  end

  it "has the right title" do
    page.has_title?("History").must_equal true
  end

  describe "Film movement page after phase update" do
    before do
      @film = FactoryGirl.create(:film, phase: "lamination")
      @date = DateTime.now
      @film.update_attributes(phase: "inspection")
      click_link "Film movement"
    end

    it "displays the serial, movement, user, and date" do
      page.has_selector?('.serial', text: @film.serial).must_equal true
      page.has_selector?('.movement', text: "lamination inspection").must_equal true
      page.has_selector?('.created_at', text: @date.strftime("%F")).must_equal true
    end
  end

  describe "FG movement page after phase update to fg" do
    before do
      @sales_order = FactoryGirl.create(:sales_order) 
      line_item = FactoryGirl.create(:line_item, sales_order: @sales_order)
      @film = FactoryGirl.create(:film, phase: "wip", line_item: line_item)
      @date = DateTime.now
      @film.update_attributes(phase: "fg")
      click_link "FG movements"
    end
    
    it "displays the serial, movement, user, and date" do
      page.has_selector?('.serial', text: @film.serial).must_equal true
      page.has_selector?('.sales_order', text: @sales_order.code).must_equal true
      page.has_selector?('.created_at', text: @date.strftime("%F")).must_equal true
    end
  end

  describe "scrap movement page after phase update to scrap" do
    before do
      @film = FactoryGirl.create(:film, phase: "nc")
      @date = DateTime.now
      @film.update_attributes(phase: "scrap")
      click_link "Scrap movements"
    end
    
    it "displays the serial, movement, user, and date" do
      page.has_selector?('.serial', text: @film.serial).must_equal true
      page.has_selector?('.created_at', text: @date.strftime("%F")).must_equal true
    end
  end

  describe "resizes page after width update" do
    before do
      @film = FactoryGirl.create(:film, width: 50, length: 70, phase: "stock")
      @date = DateTime.now
      @film.update_attributes(width: 40)
      click_link "Resizes"
    end

    it "displays the serial, dimension change, @user and date" do
      page.has_selector?('.serial', text: @film.serial).must_equal true
      page.has_selector?('.width_change', text: "50.0 40.0").must_equal true
      page.has_selector?('.created_at', text: @date.strftime("%F")).must_equal true
    end
  end
  
  describe "deletes page after delete and restore" do
    before do
      @film = FactoryGirl.create(:film)
      @date = DateTime.now
      @film.update_attributes(deleted: true)
      @film.update_attributes(deleted: false)
      click_link "Deletes"
    end

    it "displays the serial, actions, user and date" do
      page.has_selector?('.serial', text: @film.serial).must_equal true
      page.has_selector?('.action', text: "Deleted").must_equal true
      page.has_selector?('.created_at', text: @date.strftime("%F")).must_equal true
      page.has_selector?('.action', text: "Restored").must_equal true
    end
  end
end
