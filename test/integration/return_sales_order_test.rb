require 'test_helper'

class ReturnSalesOrderTest < ActionDispatch::IntegrationTest
  before do 
    use_javascript_driver
    @sales_order = FactoryGirl.create(:sales_order, ship_date: Time.zone.today)
  end

  describe "shipped tab with admin authentication" do
    let(:admin) { FactoryGirl.create(:admin) }

    before do
      log_in(admin)
      click_link "Orders"
      click_link "Shipped"
    end

    it "returns shipped sales order" do
      click_link "salesorder-#{@sales_order.id}-return"
      assert page.has_content?("#{@sales_order.code} Returned")
    end
  end

  describe "shipped tab with user authentication" do
    let(:user) { FactoryGirl.create(:user) }

    before do
      log_in(user)
      click_link "Orders"
      click_link "Shipped"
    end

    it "does not have a return button" do
      refute page.has_selector?("#salesorder-#{@sales_order.id}-return")
    end
  end
end
