class SettingsController < ApplicationController
  before_action :require_user

  def show
    @profile = current_user.civic_profile
  end

  private

  def require_user
    unless current_user
      redirect_to root_path
    end
  end
end
