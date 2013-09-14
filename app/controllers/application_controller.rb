class ApplicationController < ActionController::Base
  before_filter :restrict_by_ip
  http_basic_authenticate_with :name => "frodo", :password => "thering"
  protect_from_forgery

  private

  def restrict_by_ip
    allowed_ips = ["66.226.220.106",   #PI Dallas
                   "173.57.91.28",     #Mom's house
                   "192.168.0.2",      #Tim's house
                   "127.0.0.1"]        #localhost
    raise ActionController::RoutingError.new('Bad IP') unless allowed_ips.include?(request.remote_ip)
  end
end
