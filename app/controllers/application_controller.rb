class ApplicationController < ActionController::Base
  include DecoratorsHelper
  protect_from_forgery

  before_action :check_auth
  around_filter :set_tenant_time_zone, if: :current_tenant

private

  def current_user
    @current_user ||= User.find(session[:user_id]) if session[:user_id]
  end
  helper_method :current_user
  
  def current_tenant
    @current_tenant ||= current_user.tenant if current_user
  end
  helper_method :current_tenant

  def set_tenant_time_zone(&block)
    Time.use_zone(current_tenant.time_zone, &block)
  end

  def check_auth
    redirect_to login_url unless AuthChecker.new(current_user, request.remote_ip).has_access?
  end

  def check_admin
    redirect_to root_url unless current_user.is_admin?
  end
end
