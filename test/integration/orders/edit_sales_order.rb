require 'test_helper'

describe "Edit sales order integration" do

  before do 
    Capybara.current_driver = Capybara.javascript_driver
    @tenant = FactoryGirl.create(:tenant)
    @sales_order = FactoryGirl.create(:sales_order_with_line_item, tenant: @tenant)
  end

  describe "edit sales order form with supervisor authentication" do
    let(:supervisor) { FactoryGirl.create(:supervisor, tenant: @tenant) }

    before do
      log_in(supervisor)
      click_link "Orders"
      click_link "sales-order-#{@sales_order.id}-edit"
    end

    it "updates sales order and line items given valid attributes" do
      fill_in 'Customer', with: "New customer"
      fill_in 'Busbar', with: "Foo"
      click_button 'Update'
      within "#sales-order-#{@sales_order.id}" do
        assert page.has_content?("New customer")
        click_link @sales_order.code
        assert page.has_selector?(".line-item", text: "Busbars: Foo")
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
    let(:admin) { FactoryGirl.create(:admin, tenant: @tenant) }

    before do
      log_in(admin)
      click_link "Orders"
      click_link "sales-order-#{@sales_order.id}-edit"
    end

    it "has a SO# field" do
      assert page.has_selector?('input#sales_order_code')
    end
  end
end
