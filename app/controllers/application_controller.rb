class ApplicationController < ActionController::Base
  VALID_IPS = ["66.226.220.106",   #PI Dallas
               "120.33.232.194",   #PE Fujian
               "127.0.0.1"]        #localhost

  include DecoratorsHelper
  protect_from_forgery

  before_action :check_auth
  before_action :check_ip
  around_action :set_tenant_time_zone, if: :current_tenant
  around_action :set_raven_user_context, if: :current_user

private

  def set_raven_user_context
    begin
      Raven.user_context name: current_user.full_name
      yield
    ensure
      Raven::Context.clear!
    end
  end

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
    deny_access("Access denied: Please log in first.") unless current_user
  end

  def check_ip
    unless VALID_IPS.include?(request.remote_ip) || current_user.is_admin?
      deny_access("Access denied: invalid IP.")
    end
  end

  def deny_access(message)
    redirect_to login_url, alert: message
  end
end
