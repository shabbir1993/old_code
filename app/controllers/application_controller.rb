class ApplicationController < ActionController::Base
  VALID_IPS = ["66.226.220.106",   #PI Dallas
                "120.33.232.194",   #PE Fujian
                "127.0.0.1"]        #localhost

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
    unless current_user && (valid_ip? || current_user.is_admin?)
      redirect_to login_url 
    end
  end

  def check_admin
    redirect_to root_url unless current_user.is_admin?
  end

  def valid_ip?
    VALID_IPS.include?(request.remote_ip)
  end
end
