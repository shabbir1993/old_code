def set_user_session(user)
  session[:user_id] = 1
  allow(User).to receive(:find).with(1) { user }
end

def log_in(user)
  visit login_path
  fill_in "Username", with: user.username
  fill_in "Password", with: user.password
  click_button "Log in"
end
