class Admin::UsersController < AdminController
  def index
    @users = Kaminari.paginate_array(decorate_collection(current_tenant.widgets(User))).page(params[:page])
  end

  def new
    @user = new_user
    render layout: false
  end

  def create
    @user = decorate(new_user(user_params))
    @user.save
  end

  def edit
    @user = find_user(params[:id])
    render layout: false
  end

  def update
    @user = decorate(find_user(params[:id]))
    @user.update_attributes(user_params)
  end 

  def destroy
    @user = find_user(params[:id])
    @user.destroy
    redirect_to users_path, notice: "User #{@user.full_name} deleted."
  end

  private

  def user_params
    params.require(:user).permit(:username, :full_name, :password, :password_confirmation, :chemist, :operator, :role_level)
  end

  def new_user(parameters = nil)
    current_tenant.new_widget(User, parameters)
  end

  def find_user(id)
    current_tenant.widget(User, id)
  end
end
