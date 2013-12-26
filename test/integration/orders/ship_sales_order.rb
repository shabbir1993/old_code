require 'test_helper'

describe "Ship sales order integration" do
  before do 
    Capybara.current_driver = Capybara.javascript_driver
    @tenant = FactoryGirl.create(:tenant)
    @sales_order = FactoryGirl.create(:sales_order, tenant: @tenant)
  end

  describe "ship form with supervisor authentication" do
    let(:supervisor) { FactoryGirl.create(:supervisor, tenant: @tenant) }

    before do
      log_in(supervisor)
      click_link "Orders"
      click_link "sales-order-#{@sales_order.id}-ship"
    end

    it "ships sales order given valid inputs" do
      fill_in "Shipped", with: "2013-01-01"
      click_button "Update"
      page.has_selector?("#sales-order-#{@sales_order.id}", text: "shipped").must_equal true
    end

    it "displays error messages given invalid inputs"
  end
end
