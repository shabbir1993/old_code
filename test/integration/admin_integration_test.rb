require 'test_helper'

describe "Admin integration" do
  before do
    http_login
    click_link "Admin"
  end

  it "has the right title" do
    assert page.has_title?("Admin")
  end
end
