class SessionsController < ApplicationController
  layout false

  # GET /session/new
  def new
    redirect_to dashboard_path if current_user
  end

  # POST /session
  def create
    email = params[:email].to_s.strip.downcase
    user  = User.find_by(email: email)

    if user&.authenticate(params[:password])
      session[:user_id] = user.id

      if user.civic_profile&.onboarding_complete?
        redirect_to dashboard_path
      else
        redirect_to join_path
      end
    else
      @error = "Email or password is incorrect."
      render :new, status: :unprocessable_entity
    end
  end

  # DELETE /session
  def destroy
    session.delete(:user_id)
    session.delete(:dashboard_job_id)
    redirect_to root_path
  end
end
