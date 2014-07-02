class Admin::UsersController < AdminController
  def index
    @users = users.page(params[:page])
  end

  def new
    @user = current_tenant.new_user
    render layout: false
  end

  def create
    @user = current_tenant.new_user(user_params)
    unless @user.save
      render :display_modal_error_messages, locals: { object: @user }
    end
  end

  def edit
    session[:return_to] ||= request.referer
    @user = users.find(params[:id])
    render layout: false
  end

  def update
    @user = users.find(params[:id])
    unless @user.update(user_params)
      render :display_modal_error_messages, locals: { object: @user }
    end
  end 

  def destroy
    @user = users.find(params[:id])
    @user.destroy!
    redirect_to session.delete(:return_to), notice: "User #{@user.full_name} deleted."
  end

  private

  def users
    current_tenant.users
  end

  def user_params
    params.require(:user).permit(:username, :full_name, :password, :password_confirmation, :chemist, :operator, :role_level, :inspector)
  end
end
