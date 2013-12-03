class ApplicationController < ActionController::Base
  before_filter :authorize
  around_filter :scope_current_tenant
  around_filter :set_tenant_time_zone, :if => :current_tenant

  protect_from_forgery

private

  def restrict_by_ip
    allowed_ips = ["66.226.220.106",   #PI Dallas
                   "127.0.0.1"]        #localhost
    raise ActionController::RoutingError.new('Bad IP') unless allowed_ips.include?(request.remote_ip)
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
    Tenant.current_id = current_tenant.id if current_tenant
    yield
  ensure
    Tenant.current_id = nil
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

  def check_supervisor
    redirect_to root_url if !current_user.is_supervisor?
  end

  def check_admin
    redirect_to root_url if !current_user.is_admin?
  end

  def user_for_paper_trail
    current_user ? current_user.full_name : nil
  end
end
