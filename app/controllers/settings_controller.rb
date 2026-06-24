class SettingsController < ApplicationController
  before_action :require_user

  def show
    @profile = current_user.civic_profile
  end

  # PATCH /mvp/settings
  # Accepts a `section` param so each pillar can save independently.
  def update
    @profile = current_user.civic_profile

    if @profile.update(profile_params)
      render json: { ok: true }
    else
      render json: { ok: false, errors: @profile.errors.full_messages },
             status: :unprocessable_entity
    end
  end

  private

  def require_user
    unless current_user
      redirect_to root_path
    end
  end

  def profile_params
    params.require(:profile).permit(
      :temple_handle,
      :forum_pseudonym,
      :place_label,
      :market_display_name,
      :market_entity_name,
      :service_summary,
      :bio,
      :faith_tradition
    )
  end
end
