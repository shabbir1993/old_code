describe "Authentication integration" do
  it "allows access with valid IP" do
    page.driver.options[:headers] = {'REMOTE_ADDR' => "127.0.0.1"}
    visit root_path
  end

  it "denies access with invalid IP" do
    page.driver.options[:headers] = {'REMOTE_ADDR' => "1.2.3.4"}
    proc { visit root_path }.must_raise(ActionController::RoutingError)
  end
end
