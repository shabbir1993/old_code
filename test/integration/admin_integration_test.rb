require 'test_helper'

describe "Imports integration" do
  before do
    http_login
    visit imports_path
  end

  it "has the right title" do
    assert page.has_title?("Imports").must_equal true
  end
end
