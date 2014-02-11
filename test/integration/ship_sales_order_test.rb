require 'test_helper'

class ShipSalesOrderTest < ActionDispatch::IntegrationTest
  before do 
    use_javascript_driver
    @sales_order = FactoryGirl.create(:sales_order)
  end

  describe "ship form" do
    let(:user) { FactoryGirl.create(:user) }

    before do
      log_in(user)
      click_link "Orders"
      click_link "salesorder-#{@sales_order.id}-ship"
    end

    it "ships sales order given date input" do
      fill_in "Shipped", with: "2013-01-01"
      click_button "Update"
      assert page.has_selector?("#salesorder-#{@sales_order.id}", text: "Shipped")
    end
  end
end
