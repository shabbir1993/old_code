require 'test_helper'

describe "Charts integration" do
  before do 
    http_login
    click_link "Charts"
  end

  it "has the right title" do
    assert page.has_title?("Charts")
  end
end

