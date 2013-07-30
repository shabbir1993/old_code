def http_login
  user = "frodo"
  pw = "thering"
  if page.driver.respond_to?(:basic_auth)
      page.driver.basic_auth(user, pw)
  elsif page.driver.respond_to?(:basic_authorize)
      page.driver.basic_authorize(user, pw)
  elsif page.driver.respond_to?(:browser) && page.driver.browser.respond_to?(:basic_authorize)
      page.driver.browser.basic_authorize(user, pw)
  elsif page.driver.respond_to?(:headers=) # poltergeist
    page.driver.headers = { "Authorization" => ActionController::HttpAuthentication::Basic.encode_credentials(user, pw) }
  else
      raise "I don't know how to log in!"
  end
end
