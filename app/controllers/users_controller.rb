class UsersController < ApplicationController
  before_action :logged_in_user, only: %i(edit update destroy)
  before_action :load_user, except: %i(index new create)
  before_action :correct_user, only: %i(edit update)
  before_action :admin_user, only: %i(destroy)
  def show; end

  def index
    @pagy, @users = pagy(User.newest_created_at,
                         items: Settings.pages.page_10)
  end

  def destroy
    if @user.destroy
      flash[:success] = t("controller.user_c.destroy_success")
    else
      flash[:danger] = t("controller.user_c.destroy_fail")
    end
    redirect_to users_path
  end

  def create
    @user = User.new user_params
    if @user.save
      # some
      @user.send_activation_email
      flash[:info] = t("controller.user_c.check_email_active")
      redirect_to root_url, status: :see_other
    else
      render :new, status: :unprocessable_entity
    end
  end

  def new
    @user = User.new
  end

  def edit; end

  def update
    @user = User.find_by id: params[:id]
    if @user.update user_params
      # Handle a successful update.
      flash[:success] = t("controller.user_c.profile_updated")
      redirect_to @user
    else
      render :edit, status: :unprocessable_entity
    end
  end
  private
  def user_params
    params.require(:user).permit(:name, :email, :password,
                                 :password_confirmation)
  end

  def load_user
    @user = User.find_by id: params[:id]
    return if @user

    flash[:danger] = "User not found!"
    redirect_to root_url
  end

  def logged_in_user
    return if logged_in?

    flash[:danger] = t("controller.user_c.not_logged_in")
    store_location
    redirect_to login_url
  end

  def correct_user
    return if current_user?(@user)

    flash[:error] = t("controller.user_c.can_not_edit")
    redirect_to root_url
  end

  def admin_user
    redirect_to root_path unless current_user.admin?
  end
end
