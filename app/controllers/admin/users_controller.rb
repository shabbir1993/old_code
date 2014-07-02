class Admin::UsersController < AdminController
  def index
    @users = users.page(params[:page])
  end

  def new
    raise StandardError, "This is a test"
    @user = current_tenant.new_user
    render layout: false
  end

  def create
    @user = current_tenant.new_user(params[:user])
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
    unless @user.update(params[:user])
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
end
