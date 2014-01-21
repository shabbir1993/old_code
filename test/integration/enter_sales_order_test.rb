require 'test_helper'

class EnterSalesOrderTest < ActionDispatch::IntegrationTest

  before { use_javascript_driver }

  describe "Sales order entry form" do
    let(:user) { FactoryGirl.create(:user) }

    before do
      log_in(user)
      click_link "Orders"
      click_link 'Enter sales order'
    end

    it "creates a new sales order with line items given valid attributes" do
      fill_in 'SO#', with: "PT123T"
      click_link "Add line item"
      fill_in 'Width', with: 50
      fill_in 'Length', with: 90
      fill_in 'Qty', with: 2
      click_button 'Add sales order'
      click_link "PT123T"
      assert page.has_selector?(".panel-success .line-item", text: "50.0 x 90.0")
      assert page.has_selector?(".panel-success .line-item", text: "Qty: 2")
    end

    it "displays error messages given invalid attributes" do
      click_button 'Add sales order'
      assert page.has_selector?('.error-messages')
    end
  end
end
