require 'spec_helper'

describe SessionsController do
  fixtures :users

  it "doesn't check auth" do
    @controller.reset_session
    get :new
    expect(response.status).to eq(200)
  end

  it "doesn't check IP" do
    get :new, 'REMOTE_ADDR' => 'invalid'
    expect(response.status).to eq(200)
  end

  describe "#new" do
    it "renders the new template" do
      get :new
      expect(response).to render_template(:new)
    end
  end

  describe "#create" do

    it "successfully logs user in" do
      post :create, login: { username: users(:user).username, password: "foobar" }
      expect(session[:user_id]).to eq(users(:user).id)
      expect(request).to redirect_to(root_path)
    end

    it "fails auth with invalid username and password" do
      post :create, login: { username: "invalid", password: "foo" }
      expect(request).to render_template(:new)
    end

    it "redirects with valid username and invalid password" do
      post :create, login: { username: users(:user).username, password: "invalid_password" }
      expect(request).to render_template(:new)
    end
  end

  describe "#destroy" do

    it "clears session and redirects to login with flash notice" do
      delete :destroy
      expect(session[:user_id]).to eq(nil)
      expect(request).to redirect_to(login_url)
    end
  end
end
