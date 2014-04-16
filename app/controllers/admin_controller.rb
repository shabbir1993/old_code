class AdminController < ApplicationController
  before_filter :check_admin
  layout 'admin'

private

  def check_admin
    redirect_to root_url unless current_user.is_admin?
  end
end
