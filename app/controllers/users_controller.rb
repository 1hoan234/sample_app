class UsersController < ApplicationController
  before_action :load_user, only: %i(show)
  def show; end

  def create
    @user = User.new user_params
    if @user.save
      # some
      redirect_to @user, status: :see_other
      flash[:success] = t "User was successfully created"
    else
      render :new, status: :unprocessable_entity
    end
  end

  def new
    @user = User.new
  end

  private
  def user_params
    params.require(:user).permit(:name, :email, :password,
                                 :password_confirmation)
  end

  def load_user
    @user = User.find_by id: params[:id]
    return if @user

    flash[:warning] = t "Not found user!"
    redirect_to root_path
  end
end
