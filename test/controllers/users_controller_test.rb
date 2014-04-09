require 'test_helper'

describe Admin::UsersController do

  describe "#index" do
    before do 
      @mock_tenant = Class.new do
        define_method(:time_zone) { "Central Time (US & Canada)" }
        define_method(:widgets) { |model| [] }
        define_method(:code) { "tenant_code" }
      end.new

      @mock_admin = Class.new do 
        define_method(:is_admin?) { true }
        define_method(:tenant) { @mock_tenant }
        define_method(:full_name) { "Example User" }
      end.new
    end
    it "gets users" do
      @controller.stub :current_user, @mock_admin do
        @controller.stub :current_tenant, @mock_tenant do
          get :index
          assert_template :index
          assigns(:users).must_equal []
        end
      end
    end
  end
end
