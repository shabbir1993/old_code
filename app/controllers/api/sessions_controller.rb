module Api
  class SessionsController < ApiController
    skip_before_action :check_auth
    skip_before_action :check_ip

    def create
      user = User.find_by(username: params[:username])
      if user && user.authenticate(params[:password])
        session[:user_id] = user.id
        render json: { full_name: user.full_name }
      else
        render nothing: true, status: 403
      end
    end

    def destroy
      session[:user_id] = nil
      render nothing: true
    end
  end
end
