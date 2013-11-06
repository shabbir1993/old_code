class ApplicationController < ActionController::Base
  before_filter :authorize

  protect_from_forgery

private

  def restrict_by_ip
    allowed_ips = ["66.226.220.106",   #PI Dallas
                   "173.57.91.28",     #Mom's house
                   "192.168.0.2",      #Tim's house
                   "127.0.0.1"]        #localhost
    raise ActionController::RoutingError.new('Bad IP') unless allowed_ips.include?(request.remote_ip)
  end

  def current_user
    @current_user ||= User.find(session[:user_id]) if session[:user_id]
  end
  helper_method :current_user

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
