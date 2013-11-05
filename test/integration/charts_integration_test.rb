require 'test_helper'

describe "Charts integration" do
  let(:user) { FactoryGirl.create(:user) }
  before do 
    log_in(user)
    click_link "Charts"
  end

  it "has the right title" do
    assert page.has_title?("Charts")
  end

  it "has a stock formula totals chart" do
  end

  it "has a stock film type totals chart" do
  end

  it "has a fg utilization chart" do
  end
  
  it "has a master film yield chart" do
  end

  it "has a stock dimensions chart" do
  end

  it "has a film movement chart" do
  end

  it "has a daily fg movement chart" do
  end
  
  it "has a stock snapshots chart" do
  end
end

