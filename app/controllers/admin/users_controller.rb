class Admin::UsersController < AdminController
  def index
    @users = current_tenant.widgets(User)
  end

  def new
    @user = current_tenant.new_widget(User, params[:user])
    render layout: false
  end

  def create
    @user = current_tenant.new_widget(User, params[:user])
    @user.save
  end

  def edit
    @user = current_tenant.widget(User, params[:id])
    render layout: false
  end

  def update
    @user = current_tenant.widget(User, params[:id])
    @user.update_attributes(user_params)
  end 

  def destroy
    @user = current_tenant.widget(User, params[:id])
    @user.destroy!
    redirect_to users_path, notice: "User #{@user.full_name} deleted."
  end

  private

  def user_params
    params.require(:user).permit(:username, :full_name, :password, :password_confirmation, :chemist, :operator, :role_level)
  end

  def users
    Kaminari.paginate_array(decorate_collection(@users)).page(params[:page])
  end
  helper_method :users

  def user
    decorate(@user)
  end
  helper_method :user
end
