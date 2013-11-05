class Admin::UsersController < AdminController
  def index
    @users = User.page(params[:page])
  end

  def new
    @user = User.new
    render layout: false
  end

  def create
    @user = User.create(params[:user])
  end

  def edit
    @user = User.find(params[:id])
    render layout: false
  end

  def update
    @user = User.find(params[:id])
    @user.update_attributes(params[:user])
  end 

  def destroy
    @user = User.find(params[:id])
    @user.destroy
    redirect_to users_path, notice: "User #{@user.full_name} deleted."
  end
end
