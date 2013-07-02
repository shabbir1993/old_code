describe "Imports integration" do
  before { visit imports_path }

  it "has the right title" do
    assert page.has_title?("Imports").must_equal true
  end
end
