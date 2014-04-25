require 'spec_helper'

describe AdminController do
  controller do
    def index
      render nothing: true
    end
  end

  let(:tenant) { instance_double("Tenant", time_zone: "Beijing") }

  context "when logged in as an admin" do
    let(:admin) { instance_double("User", admin?: true, tenant: tenant, full_name: "Some Name").as_null_object }

    before do 
      session[:user_id] = 1
      allow(User).to receive(:find).with(1) { admin }
    end

    it "grants access" do
      get :index
      expect(response.status).to eq(200)
    end

    it "sets the time zone" do
      expect(Time).to receive(:use_zone).with("Beijing")
      get :index
    end

    it "sets raven user context" do
      expect(Raven).to receive(:user_context).with(name: "Some Name")
      get :index
    end

    it "ensures raven contexts are cleared" do
      expect(Raven::Context).to receive(:clear!)
      get :index
    end
  end

  context "when logged in as a user with a valid IP" do
    let(:user) { instance_double("User", admin?: false, tenant: tenant).as_null_object }

    before do 
      @request.env['REMOTE_ADDR'] = '127.0.0.1'
      session[:user_id] = 1
      allow(User).to receive(:find).with(1) { user }
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
