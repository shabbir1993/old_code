require 'spec_helper'

describe Admin::UsersController do
  fixtures :users
  let(:user_attrs) { { full_name: "Name", 
                  username: "username", 
                  password: "foobar", 
                  password_confirmation: "foobar" } }

  context "admin session" do
    before do
      set_user_session(users(:admin))
    end

    describe "#index" do
      it "displays current tenant's users" do
        get :index
        expect(assigns(:users)).to match([users(:user), users(:admin)])
        expect(response).to render_template(:index)
      end
    end

    describe "#new" do
      it "assigns a new tenant user" do
        get :new
        expect(assigns(:user).tenant_code).to eq('pi')
        expect(response).to render_template(:new)
      end
    end

    describe "#create" do
      it "successfully creates a new tenant user" do
        expect { xhr :post, :create, user: user_attrs , format: :js }.to change { User.count }.by(1)
        expect(response).to render_template(:create)
      end

      it "displays error messages when invalid" do
        expect { xhr :post, :create, user: {}, format: :js }.to_not change { User.count }
        expect(response).to render_template(:display_error_messages)
      end
    end

    describe "#edit" do
      it "assigns tenant user" do
        get :edit, id: users(:user).id
        expect(assigns(:user)).to eq(users(:user))
      end
    end

    describe "#update" do
      it "successfully updates tenant users' username" do
        xhr :patch, :update, id: users(:user).id, user: { username: "updated_username" }, format: :js
        expect(users(:user).reload.username).to eq("updated_username")
        expect(response).to render_template(:update)
      end

      it "displays error messages when unsuccessful" do
        xhr :patch, :update, id: users(:user).id, user: { username: "" }, format: :js
        expect(users(:user).reload.username).to_not eq("")
        expect(response).to render_template(:display_error_messages)
      end
    end

    describe "#destroy" do
      it "redirects to users index with flash notice" do
        expect { delete :destroy, id: users(:user).id }.to change { User.count }.by(-1)
        expect(response).to redirect_to(users_path)
      end
    end
  end
end
