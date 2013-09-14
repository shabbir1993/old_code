require 'test_helper'

describe "Charts integration" do
  before do 
    http_login
    click_link "Charts"
  end

  it "has the right title" do
    assert page.has_title?("Charts")
  end

  it "has a stock formula totals chart" do
    click_link "Stock formula totals"
    assert page.has_selector?("div#stock-formula-totals")
  end

  it "has a stock film type totals chart" do
    click_link "Stock film type totals"
    assert page.has_selector?("div#stock-film-type-totals")
  end

  it "has a fg utilization chart" do
    click_link "FG utilization"
    assert page.has_selector?("div#fg-utilization")
  end
  
  it "has a master film yield chart" do
    click_link "Master yield"
    assert page.has_selector?("div#master-film-yield")
  end

  it "has a stock dimensions chart" do
    click_link "Stock dimensions"
    assert page.has_selector?("div#stock-dimensions")
  end
end

