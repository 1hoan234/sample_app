class SessionsController < ApplicationController
  def create
    user = User.find_by email: params.dig(:session, :email)&.downcase
    if user.try(:authenticate, params.dig(:session, :password))
      # Log the user in and redirect to the user's show page.
      reset_session
      log_in user
      params.dig(:session, :remember_me) == "1" ? remember(user) : forget(user)
      redirect_to user, status: :see_other
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
end
