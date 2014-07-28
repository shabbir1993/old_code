module Api
  class SessionsController < ApplicationController
    skip_before_filter  :verify_authenticity_token
    respond_to :json

    def create
      user = User.find_by(username: params[:username])
      if user && user.authenticate(params[:password])
        session[:user_id] = user.id
        render nothing: true, status: 200
      else
        render nothing: true, status: 403
      end
    end

    def destroy
      session[:user_id] = nil
      render status: 200
    end
  end
end
