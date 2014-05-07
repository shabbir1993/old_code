require 'spec_helper'

describe AdminController do
  fixtures :users

  controller do
    def index
      render nothing: true
    end
  end

  context "as admin" do
    before do
      set_user_session(users(:admin))
    end

    it "grants access" do
      get :index
      expect(response.status).to eq(200)
    end
  end

  context "when logged in as a user with a valid IP" do
    before do 
      set_user_session(users(:user))
      @request.env['REMOTE_ADDR'] = '127.0.0.1'
    end

    it "redirects to root" do
      get :index
      expect(response).to redirect_to(root_url)
    end
  end

  context "without login" do
    it "redirects to login" do
      get :index
      expect(response).to redirect_to(login_url)
    end
  end
end
