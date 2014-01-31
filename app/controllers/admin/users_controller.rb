class Admin::UsersController < AdminController
  def index
    @users = current_tenant.users.page(params[:page])
  end

  def new
    @user = current_tenant.new_user(params[:user])
    render layout: false
  end

  def create
    @user = current_tenant.new_user(params[:user])
    @user.save
  end

  def edit
    @user = current_tenant.user(params[:id])
    render layout: false
  end

  def update
    @user = current_tenant.user(params[:id])
    @user.update_attributes(params[:user])
  end 

  def destroy
    @user = current_tenant.user(params[:id])
    @user.destroy
    redirect_to users_path, notice: "User #{@user.full_name} deleted."
  end
end
