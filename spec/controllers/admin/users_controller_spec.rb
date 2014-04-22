require 'spec_helper'

describe Admin::UsersController do
  let(:tenant) { instance_double("Tenant", time_zone: "Beijing").as_null_object }
  let(:admin) { instance_double("User", is_admin?: true, tenant: tenant).as_null_object }
  let(:tenant_users) { instance_double("TenantAssets") }

  before do
    login(admin)
    allow(TenantAssets).to receive(:new).with(tenant, User) { tenant_users }
  end

  describe "#index" do
    let(:users) { double }

    before do
      allow(tenant_users).to receive(:all) { users }
      get :index
    end

    it "assigns users" do
      expect(assigns(:users)).to eq(users)
    end

    it "renders index template" do
      expect(response).to render_template(:index)
    end
  end

  describe "#new" do
    let(:new_user) { instance_double("User") }

    before do 
      allow(tenant_users).to receive(:new) { new_user }
      get :new
    end

    it "assigns new user" do
      expect(assigns(:user)).to eq(new_user)
    end

    it "renders the new template" do
      expect(response).to render_template(:new)
    end
  end

  describe "#create" do
    let(:new_user) { instance_double("User") }

    before do 
      allow(tenant_users).to receive(:new) { new_user }
    end

    context "with valid attributes" do
      before do
        allow(new_user).to receive(:save) { true }
        post :create, user: {}, format: 'js'
      end

      it "assigns new user" do
        expect(assigns(:user)).to eq(new_user)
      end

      it "renders the create template" do
        expect(response).to render_template(:create)
      end
    end
      
    context "with invalid attributes" do
      before do
        allow(new_user).to receive(:save) { false }
        post :create, user: {}, format: 'js'
      end

      it "assigns new user" do
        expect(assigns(:user)).to eq(new_user)
      end

      it "renders the display error messages template" do
        expect(response).to render_template(:display_error_messages)
      end
    end
  end

  describe "#edit" do
    let(:user) { instance_double("User") }

    before do 
      allow(tenant_users).to receive(:find_by_id).with("1") { user }
      get :edit, id: 1
    end

    it "assigns user" do
      expect(assigns(:user)).to eq(user)
    end

    it "renders the edit template" do
      expect(response).to render_template(:edit)
    end
  end

  describe "#update" do
    let(:user) { instance_double("User") }

    before do 
      allow(tenant_users).to receive(:find_by_id).with("1") { user }
    end

    context "with valid attributes" do
      before do
        allow(user).to receive(:update_attributes).with({}) { true }
        patch :update, id: 1, user: {}, format: 'js'
      end

      it "assigns user" do
        expect(assigns(:user)).to eq(user)
      end

      it "renders the update template" do
        expect(response).to render_template(:update)
      end
    end
      
    context "with invalid attributes" do
      before do
        allow(user).to receive(:update_attributes).with({}) { false }
        patch :update, id: 1, user: {}, format: 'js'
      end

      it "assigns user" do
        expect(assigns(:user)).to eq(user)
      end

      it "renders the display error messages template" do
        expect(response).to render_template(:display_error_messages)
      end
    end
  end

  describe "#destroy" do
    let(:user) { instance_double("User").as_null_object }

    before do 
      allow(tenant_users).to receive(:find_by_id).with("1") { user }
    end

    describe "when destroy is successful" do
      before do 
        expect(user).to receive(:destroy!) { user }
        get :destroy, id: 1
      end

      it "assigns user" do
        expect(assigns(:user)).to eq(user)
      end

      it "redirects to users index" do
        expect(response).to redirect_to(users_path)
      end

      it "sends a notice flash message" do
        expect(flash[:notice]).to match(/deleted/i)
      end
    end

    describe "when destroy throws an error" do
      before do 
        expect(user).to receive(:destroy!).and_raise(ActiveRecord::RecordNotDestroyed)
        get :destroy, id: 1
      end

      it "assigns user" do
        expect(assigns(:user)).to eq(user)
      end

      it "redirects to users index" do
        expect(response).to redirect_to(users_path)
      end

      it "sends an error flash message" do
        expect(flash[:alert]).to match(/error/i)
      end
    end
  end
end
