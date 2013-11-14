require 'test_helper'

describe "Orders integration" do
  let(:user) { FactoryGirl.create(:user) }

  before do
    Capybara.current_driver = Capybara.javascript_driver
    log_in(user)
    click_link "Orders"
  end

  it "has the right title" do
    page.has_title?("Orders").must_equal true
  end

  describe "new sales order form" do
    before { click_link "Enter sales order" }

    it "creates a sales order given valid attributes" do
      fill_in "SO#", with: "PT123P"
      fill_in "Customer", with: "POLYTRON"
      fill_in "Ship to", with: "Location"
      fill_in "Released", with: "2013-01-21"
      fill_in "Due", with: "2013-03-31"
      click_link "Add line item"
      fill_in "Width", with: 50
      fill_in "Length", with: 80
      fill_in "Qty", with: 3
      choose "Glass"
      fill_in "Wires", with: "1M"
      fill_in "Busbars", with: "A"
      fill_in "Note", with: "New note"
      click_button "Add sales order"
      within ".panel-success" do
        page.has_content?('PT123P').must_equal true
        page.has_content?('POLYTRON').must_equal true
        page.has_content?('Location').must_equal true
        page.has_content?('Released: 2013-01-21').must_equal true
        page.has_content?('Due: 2013-03-31').must_equal true
      end
      click_link "PT123P"
      within ".line-item" do
        page.has_content?("50")
        page.has_content?("80")
        page.has_content?("Qty: 3")
        page.has_content?("Glass")
        page.has_content?("Wires: 1M")
        page.has_content?("Busbars: A")
        page.has_content?("New note")
      end
    end

    it "displays error messages given invalid attributes" do
      click_button "Add sales order"
      page.has_selector?('.error-messages', text: "can't be blank").must_equal true
    end
  end

  describe "with existing order" do
    before do
      @sales_order = FactoryGirl.create(:sales_order)
      @line_item = FactoryGirl.create(:line_item, quantity: 3, sales_order: @sales_order)
      @film_1 = FactoryGirl.create(:film, phase: "stock", sales_order: @sales_order)
      @film_2 = FactoryGirl.create(:film, phase: "fg", sales_order: @sales_order)
      click_link "Orders"
    end

    it "has a working ship button" do
      click_link "sales-order-#{@sales_order.id}-ship"
      page.has_selector?("#sales-order-#{@sales_order.id}", 
                         text: "#{@sales_order.code} shipped").must_equal true
    end

    describe "edit sales order form" do
      before do
        click_link "sales-order-#{@sales_order.id}-edit"
      end

      it "displays the correct number of line item fields" do
        page.has_selector?('fieldset.line-item-fields', count: 1).must_equal true
      end

      it "updates the sales order given valid attributes" do
        fill_in "Customer", with: "NEWCOMPANY"
        fill_in "Ship to", with: "New location"
        fill_in "Released", with: "2014-01-21"
        fill_in "Due", with: "2014-03-31"
        click_link('remove', match: :first)
        page.has_selector?('fieldset.line-item-fields').must_equal false
        click_button "Update"
        click_link @sales_order.code
        page.has_selector?("#line-item-#{@line_item.id}").must_equal false
        within "#sales-order-#{@sales_order.id}" do
          page.has_content?("NEWCOMPANY").must_equal true
          page.has_content?("New location").must_equal true
          page.has_content?("Released: 2014-01-21").must_equal true
          page.has_content?("Due: 2014-03-31").must_equal true
        end
      end

      it "has a working delete button" do
        click_link "Delete"
        page.has_selector?("#sales-order-#{@sales_order.id}", 
                           text: "#{@sales_order.code} deleted").must_equal true
      end
    end

    describe "with line item panels extended" do
      before { click_link @sales_order.code }

      it "displays line item" do
        page.has_selector?("#line-item-#{@line_item.id}").must_equal true
      end

      it "displays assigned films" do
        page.has_content?(@film_1.serial).must_equal true
        page.has_content?(@film_2.serial).must_equal true
      end

      it "unassigns film by button click" do
        click_link "film-#{@film_1.id}-unassign"
        page.has_selector?("#film-#{@film_1.id}-label.label-default", 
                           text: "#{@film_1.serial} unassigned").must_equal true
      end
    end
  end
end
