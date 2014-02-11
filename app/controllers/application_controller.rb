class ApplicationController < ActionController::Base
  include DecoratorsHelper

  before_action :authorize
  around_filter :scope_current_tenant
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

  def scope_current_tenant
    if current_tenant
      Tenant.current_id = current_tenant.id
      Tenant.current_area_divisor = current_tenant.area_divisor
      Tenant.current_small_area_cutoff = current_tenant.small_area_cutoff
      Tenant.current_yield_multiplier = current_tenant.yield_multiplier
    end
    yield
  ensure
    Tenant.current_id = nil
    Tenant.current_area_divisor = nil
    Tenant.current_small_area_cutoff = nil
    Tenant.current_yield_multiplier = nil
  end

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

  def user_for_paper_trail
    current_user ? current_user.full_name : nil
  end
end
