class ApplicationController < ActionController::Base
  VALID_IPS = ["66.226.220.106",   #PI Dallas
               "66.226.207.10",
               "120.33.232.194",   #PE Fujian
               "127.0.0.1"]        #localhost

  protect_from_forgery

  before_action :check_auth
  before_action :check_ip
  before_action :set_user_context, if: :current_user
  around_action :set_tenant_time_zone, if: :current_tenant

private

  def current_user
    @current_user ||= User.find(session[:user_id]) if session[:user_id]
  rescue JSON::ParserError => e
    capture_exception(e)
    reset_session
    redirect_to login_url
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
    deny_access unless current_user
  end

  def check_ip
    unless VALID_IPS.include?(request.remote_ip) || current_user.admin?
      flash[:alert] = "Access denied: invalid IP"
      deny_access
    end
  end

  def deny_access
    session[:forward_to] = request.fullpath
    redirect_to login_url
  end

  def check_admin
    redirect_to root_url unless current_user.admin?
  end

  def any_searches?
    filtering_params.any?
  end
  helper_method :any_searches?

  def set_user_context
    Raven.user_context username: current_user.username
  end
end
