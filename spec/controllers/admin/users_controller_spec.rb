require 'spec_helper'

describe Admin::UsersController do
  let(:tenant) { instance_double("Tenant", time_zone: "Beijing").as_null_object }
  let(:admin) { instance_double("User", admin?: true, tenant: tenant).as_null_object }
  let(:users) { double }
  let(:user) { instance_double("User").as_null_object }
  let(:new_user) { instance_double("User").as_null_object }

  before do
    set_user_session(admin)
    allow(tenant).to receive(:users) { users }
    allow(users).to receive(:find).with("1") { user }
    allow(tenant).to receive(:new_user) { new_user }
  end

  describe "#index" do
    let(:paged_users) { double }

    before do
      allow(users).to receive(:page).with("2") { paged_users }
      get :index, page: 2
    end

    it "assigns current tenant users" do
      expect(assigns(:users)).to eq(paged_users)
    end
  end

  describe "#new" do
    it "assigns new tenant user" do
      get :new
      expect(assigns(:user)).to eq(new_user)
    end
  end

  describe "#create" do
    it "creates a new tenant user when valid" do
      allow(new_user).to receive(:save) { new_user }
      xhr :post, :create, user: {}, format: :js
      expect(response).to render_template(:create)
    end

    it "displays error messages when invalid" do
      allow(new_user).to receive(:save) { false }
      xhr :post, :create, user: {}, format: :js
      expect(response).to render_template(:display_error_messages)
    end
  end

  describe "#edit" do
    it "assigns tenant user" do
      get :edit, id: 1
      expect(assigns(:user)).to eq(user)
    end
  end

  describe "#update" do
    it "updates tenant user when valid" do
      allow(user).to receive(:update_attributes) { user }
      xhr :patch, :update, id: 1, user: {}, format: :js
      expect(response).to render_template(:update)
    end

    it "displays error messages when invalid" do
      allow(user).to receive(:update_attributes) { false }
      xhr :patch, :update, id: 1, user: {}, format: :js
      expect(response).to render_template(:display_error_messages)
    end
  end

  describe "#destroy" do
    describe "when destroy is successful" do
      before do 
        expect(user).to receive(:destroy!) { user }
      end

      it "redirects to users index with flash notice" do
        delete :destroy, id: 1
        expect(response).to redirect_to(users_path)
        expect(flash[:notice]).to match(/deleted/i)
      end
    end

    describe "when destroy throws an error" do
      before do 
        expect(user).to receive(:destroy!).and_raise(ActiveRecord::RecordNotDestroyed)
      end

      it "redirects to users index with flash alert" do
        delete :destroy, id: 1
        expect(response).to redirect_to(users_path)
        expect(flash[:alert]).to match(/error/i)
      end
    end
  end
end
