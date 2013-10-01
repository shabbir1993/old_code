class SessionsController < ApplicationController
  skip_before_filter :authorize

  def new
    render layout: false
  end

  def create
    user = User.find_by_username(params[:login][:username])
    if user && user.authenticate(params[:login][:password])
      session[:user_id] = user.id
      redirect_to root_path
    else
      flash.now[:error] = "Invalid login"
      render "new", layout: false
    end
  end

  def destroy
    session[:user_id] = nil
    redirect_to root_url, notice: "Logged out"
  end
end
