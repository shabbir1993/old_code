class AdminController < ApplicationController
  before_filter :check_admin
  layout 'admin'
end
