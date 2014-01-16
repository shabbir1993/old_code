def log_in(user)
  visit login_path
  fill_in "Username", with: user.username
  fill_in "Password", with: user.password
  click_button "Log in"
end

def with_invalid_ip
  page.driver.options[:headers] = {'REMOTE_ADDR' => "1.2.3.4"}
  begin
    yield
  ensure
    page.driver.options[:headers] = {'REMOTE_ADDR' => "127.0.0.1"}
  end
end
