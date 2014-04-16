def login(user)
  session[:user_id] = 1
  allow(User).to receive(:find).with(1) { admin }
end
