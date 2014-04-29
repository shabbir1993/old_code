require 'spec_helper'

describe ApplicationController do
  controller do
    def index
      render nothing: true
    end
  end

  let(:tenant) { instance_double("Tenant", time_zone: "Beijing") }

  context "when logged in as a user" do
    let(:user) { instance_double("User", admin?: false, tenant: tenant, full_name: "Some Name").as_null_object }

    before do 
      session[:user_id] = 1
      allow(User).to receive(:find).with(1) { user }
    end

    context "with a valid IP" do
      before do 
        @request.env['REMOTE_ADDR'] = '127.0.0.1'
      end

      it "sets the time zone" do
        expect(Time).to receive(:use_zone).with("Beijing")
        get :index
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
    let(:user) { instance_double("User", admin?: true, tenant: tenant).as_null_object }

    before do 
      session[:user_id] = 1
      allow(User).to receive(:find).with(1) { user }
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

    it "doesn't set tenant time zone" do
      expect(Time).to_not receive(:use_zone)
      get :index
    end
  end
end
