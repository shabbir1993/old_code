class Admin::UsersController < AdminController
  def index
    @users = users.page(params[:page])
  end

  def new
    @user = current_tenant.new_user
    render layout: false
  end

  def create
    @user = current_tenant.new_user(params[:user])
    render :display_error_messages unless @user.save
  end

  def edit
    session[:return_to] ||= request.referer
    @user = users.find(params[:id])
    render layout: false
  end

  def update
    @user = users.find(params[:id])
    render :display_error_messages unless @user.update(params[:user])
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
end
