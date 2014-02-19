require 'test_helper'

class CancelSalesOrderTest < ActionDispatch::IntegrationTest
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

    it "cancels orders" do
      click_link "Cancel order"
      assert page.has_selector?("#salesorder-#{@sales_order.id}", text: "cancelled")
    end
  end
end
