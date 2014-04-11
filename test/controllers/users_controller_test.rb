require 'test_helper'

describe Admin::UsersController do

  def mock_tenant
    @mock_tenant ||= Class.new do
      define_method(:time_zone) { "Central Time (US & Canada)" }
      define_method(:code) { "tenant_code" }
    end.new
  end

  def mock_admin(tenant = mock_tenant)
    @mock_admin ||= Class.new do
      define_method(:is_admin?) { true }
      define_method(:tenant) { tenant }
      define_method(:full_name) { "Example User" }
    end.new
  end
    

  describe "#index" do
    before do
      @user_manager = Minitest::Mock.new
      @users = Object.new
    end

    it "assigns users" do
      @controller.stub :current_user, mock_admin do
        @controller.stub :user_manager, @user_manager do
          @user_manager.expect :all_widgets, @users
          get :index
          assigns(:users).must_equal @users
        end
      end
    end
  end
end
