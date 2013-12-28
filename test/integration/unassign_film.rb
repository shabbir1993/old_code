require 'test_helper'

describe "Unassign sales order integration" do

  before do 
    Capybara.current_driver = Capybara.javascript_driver
    @tenant = FactoryGirl.create(:tenant)
    @sales_order = FactoryGirl.create(:sales_order, tenant: @tenant)
    @film = FactoryGirl.create(:film, sales_order: @sales_order, tenant: @tenant)
  end

  describe "orders page with supervisor authentication" do

    let(:supervisor) { FactoryGirl.create(:supervisor, tenant: @tenant) }
    before do
      log_in(supervisor)
      click_link "Orders"
    end

    it "unassigns film from sales order" do
      click_link "film-#{@film.id}-unassign"
      page.has_selector?("#film-#{@film.id}-label", 
                         text: "#{@film.serial} unassigned").must_equal true
    end
  end
end
