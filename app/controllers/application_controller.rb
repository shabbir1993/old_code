class ApplicationController < ActionController::Base
  before_filter :restrict_by_ip
  http_basic_authenticate_with :name => "frodo", :password => "thering"
  protect_from_forgery

  private

  def restrict_by_ip
    allowed_ips = ["24.206.79.53", "192.168.0.2", "66.226.220.106", "127.0.0.1"]
    raise ActionController::RoutingError.new('Bad IP') unless allowed_ips.include?(request.remote_ip)
  end
end
