class SessionsController < ApplicationController
  def create
    user = User.find_by email: params.dig(:session, :email)&.downcase
    if user.try(:authenticate, params.dig(:session, :password))
      perform_login user
    else
      # Create an error message.
      flash.now[:danger] = t "invalid_email_password_combination"
      render :new, status: :unprocessable_entityendend
    end
  end

  def destroy
    log_out
    redirect_to root_url, status: :see_other
  end

  private

  def perform_login user
    if user.activated?
      params.dig(:session, :remember_me) == "1" ? remember(user) : forget(user)
      log_in user
      redirect_back_or user
    else
      flash[:warning] = t("controller.sessions_c.acc_not_active")
      redirect_to root_url, status: :see_other
    end
  end
end
