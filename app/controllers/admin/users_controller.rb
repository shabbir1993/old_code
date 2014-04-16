class Admin::UsersController < AdminController
  def index
    @users = tenant_users.all
  end

  def new
    @user = tenant_users.new
    render layout: false
  end

  def create
    @user = tenant_users.new(params[:user])
    render :display_error_messages unless @user.save
  end

  def edit
    @user = tenant_users.find_by_id(params[:id])
    render layout: false
  end

  def update
    @user = tenant_users.find_by_id(params[:id])
    render :display_error_messages unless @user.update_attributes(params[:user])
  end 

  def destroy
    @user = tenant_users.find_by_id(params[:id])
    @user.destroy!
    redirect_to users_path, notice: "User #{@user.full_name} deleted."
  rescue ActiveRecord::RecordNotDestroyed => e
    capture_exception(e)
    redirect_to users_path, alert: "Error: user could not be deleted."
  end

  private

  def users
    @users.page(params[:page])
  end
  helper_method :users

  def user
    @user
  end
  helper_method :user

  def tenant_users
    @tenant_users ||= TenantAssets.new(current_tenant, User)
  end
end
