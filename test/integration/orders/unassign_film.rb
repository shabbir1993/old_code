require 'test_helper'

describe "Unassign sales order integration" do

  before do 
    Capybara.current_driver = Capybara.javascript_driver
    @tenant = FactoryGirl.create(:tenant)
  end
end
