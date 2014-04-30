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
    @user = users.find(params[:id])
    render layout: false
  end

  def update
    @user = users.find(params[:id])
    render :display_error_messages unless @user.update_attributes(params[:user])
  end 

  def destroy
    @user = users.find(params[:id])
    @user.destroy!
    redirect_to users_path, notice: "User #{@user.full_name} deleted."
  rescue ActiveRecord::RecordNotDestroyed => e
    capture_exception(e)
    redirect_to users_path, alert: "Error: user could not be deleted."
  end

  private

  def users
    current_tenant.users
  end
end
