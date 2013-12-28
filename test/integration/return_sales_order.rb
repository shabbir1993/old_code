require 'test_helper'

describe "Return sales order integration" do
  before do 
    Capybara.current_driver = Capybara.javascript_driver
    @tenant = FactoryGirl.create(:tenant)
    @sales_order = FactoryGirl.create(:sales_order, tenant: @tenant, ship_date: Time.zone.today)
  end

  describe "shipped tab with supervisor authentication" do
    let(:admin) { FactoryGirl.create(:admin, tenant: @tenant) }

    before do
      log_in(admin)
      click_link "Orders"
      click_link "Shipped"
    end

    it "returns shipped sales order" do
      save_screenshot("ss.png")
      click_link "sales-order-#{@sales_order.id}-return"
      assert page.has_content?("#{@sales_order.code} returned")
    end
  end
end
