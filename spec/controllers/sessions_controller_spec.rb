require 'spec_helper'

describe SessionsController do
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
    context "with auth" do
      let(:user) { instance_double("User", id: 1) }

      before do
        allow(User).to receive(:find_by).with(username: "valid_user") { user }
        allow(user).to receive(:authenticate).with("valid_password") { user }
        post :create, login: { username: "valid_user", password: "valid_password" }
      end

      it "logs user in and redirects to root" do
        expect(session[:user_id]).to eq(1)
        expect(request).to redirect_to(root_path)
      end
    end

    context "with invalid username" do
      before do
        allow(User).to receive(:find_by).with(username: "invalid") { nil }
        post :create, login: { username: "invalid", password: "foo" }
      end

      it "re-renders with flash error" do
        expect(flash.now[:error]).to match(/invalid/i)
        expect(request).to render_template(:new)
      end
    end

    context "with valid username and invalid password" do
      let(:user) { instance_double("User", id: 1) }

      before do
        allow(User).to receive(:find_by).with(username: "valid_user") { user }
        allow(user).to receive(:authenticate).with("invalid_password") { false }
        post :create, login: { username: "valid_user", password: "invalid_password" }
      end

      it "re-renders with flash error" do
        expect(flash.now[:error]).to match(/invalid/i)
        expect(request).to render_template(:new)
      end
    end
  end

  describe "#destroy" do
    before { delete :destroy }

    it "clears session and redirects to login with flash notice" do
      expect(session[:user_id]).to eq(nil)
      expect(request).to redirect_to(login_url)
      expect(flash[:notice]).to match(/logged out/i)
    end
  end
end
