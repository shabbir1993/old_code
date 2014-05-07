require 'spec_helper'

describe ApplicationController do
  fixtures :users

  controller do
    def index
      render nothing: true
    end
  end

  context "when logged in as a user" do
    before do 
      set_user_session(users(:user))
    end

    context "with a valid IP" do
      before do 
        @request.env['REMOTE_ADDR'] = '127.0.0.1'
      end

      it "sets the time zone" do
        get :index
        expect(Time.zone.name).to eq("Central Time (US & Canada)")
      end

      it "grants access with a valid IP" do
        get :index
        expect(response.status).to eq(200)
      end
    end

    it "redirects to login_url with invalid IP" do
      get :index, 'REMOTE_ADDR' => 'invalid'
      expect(response).to redirect_to(login_url)
    end
  end

  context "when logged in as an admin" do
    before do 
      set_user_session(users(:admin))
    end

    it "grants access with an invalid IP" do
      get :index, 'REMOTE_ADDR' => 'invalid'
      expect(response.status).to eq(200)
    end
  end

  context "without login" do
    it "redirects to login_url" do
      get :index
      expect(response).to redirect_to login_url
    end
  end
end
