require 'spec_helper'

describe Admin::UsersController do

  let(:tenant) { double(time_zone: "Central Time (US & Canada)") }
  let(:admin) { double(is_admin?: true, tenant: tenant) }

  before do
    session[:user_id] = 1
    allow(User).to receive(:find).with(1) { admin }
  end

  let(:users_manager) { double }

  before do
    allow(TenantWidgetsManager).to receive(:new).with(tenant, User) { users_manager }
  end

  describe "#index" do
    let(:users) { double }

    before do
      allow(users_manager).to receive(:all_widgets) { users }
      get :index
    end

    it "assigns users" do
      expect(assigns(:users)).to eq(users)
    end

    it "renders index template" do
      expect(response).to render_template("index")
    end
  end

  describe "#new" do
    let(:new_user) { double }

    before do 
      allow(users_manager).to receive(:new_widget) { new_user }
      get :new
    end

    it "assigns new user" do
      expect(assigns(:user)).to eq(new_user)
    end

    it "renders the new template" do
      expect(response).to render_template("new")
    end
  end
end
