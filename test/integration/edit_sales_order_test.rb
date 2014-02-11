require 'test_helper'

class EditSalesOrderTest < ActionDispatch::IntegrationTest

  before do 
    use_javascript_driver
    @sales_order = FactoryGirl.create(:sales_order_with_line_item)
  end

  describe "edit sales order form" do
    let(:user) { FactoryGirl.create(:user) }

    before do
      log_in(user)
      click_link "Orders"
      click_link "salesorder-#{@sales_order.id}-edit"
    end

    it "updates sales order and line items given valid attributes" do
      fill_in 'Customer', with: "New customer"
      fill_in 'Busbar', with: "40 Foobars"
      click_button 'Update'
      within "#salesorder-#{@sales_order.id}" do
        assert page.has_content?("New customer")
        click_link "Line items"
        assert page.has_selector?(".lineitem", text: "40 Foobars")
      end
    end

    it "displays error messages given invalid attributes" do
      fill_in 'Width', with: ""
      click_button 'Update'
      assert page.has_selector?('.error-messages')
    end

    it "does not have a SO# field" do
      refute page.has_selector?('input#sales_order_code')
    end
  end

  describe "edit sales order form with admin authentication" do
    let(:admin) { FactoryGirl.create(:admin) }

    before do
      log_in(admin)
      click_link "Orders"
      click_link "salesorder-#{@sales_order.id}-edit"
    end

    it "has a SO# field" do
      assert page.has_selector?('input#sales_order_code')
    end
  end
end
