class ApplicationController < ActionController::Base
  include DecoratorsHelper

  before_action :authorize
  around_filter :set_tenant_time_zone, if: :current_tenant

  protect_from_forgery

private

  def restrict_by_ip
    raise ActionController::RoutingError.new('Bad IP') unless ALLOWED_IPS.include?(request.remote_ip)
  end

  def current_user
    @current_user ||= User.unscoped.find(session[:user_id]) if session[:user_id]
  end
  helper_method :current_user
  
  def current_tenant
    @current_tenant ||= current_user.tenant if current_user
  end
  helper_method :current_tenant

  def set_tenant_time_zone(&block)
    Time.use_zone(current_tenant.time_zone, &block)
  end

  def authorize
    if current_user
      restrict_by_ip unless current_user.is_admin?
    else
      redirect_to login_url
    end
  end

  def check_admin
    redirect_to root_url if !current_user.is_admin?
  end
end
