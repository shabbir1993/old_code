class AmoController < ApplicationController
  skip_before_action :check_auth
  skip_before_action :check_ip
end
