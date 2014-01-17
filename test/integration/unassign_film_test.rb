require 'test_helper'

class UnassignFilmTest < ActionDispatch::IntegrationTest

  before do 
    use_javascript_driver
    @sales_order = FactoryGirl.create(:sales_order)
    @film = FactoryGirl.create(:film, sales_order: @sales_order)
  end

  describe "orders page with supervisor authentication" do
    let(:supervisor) { FactoryGirl.create(:supervisor) }

    before do
      log_in(supervisor)
      click_link "Orders"
    end

    it "unassigns film from sales order" do
      click_link "film-#{@film.id}-unassign"
      assert page.has_selector?("#film-#{@film.id}-label", text: "#{@film.serial} unassigned")
    end
  end
end
