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
      within ".lineitem-fields" do
        fill_in 'Width', with: 50
        fill_in 'Length', with: 90
        fill_in 'Qty', with: 2
      end
      click_button 'Add sales order'
      click_link "Line items"
      within(".lineitem") do
        assert page.has_content?("50")
        assert page.has_content?("90")
        assert page.has_content?("2")
      end
    end

    it "displays error messages given invalid attributes" do
      click_button 'Add sales order'
      assert page.has_selector?('.error-messages')
    end
  end
end
