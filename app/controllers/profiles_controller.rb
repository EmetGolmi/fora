# ProfilesController
#
# Public provider card at /p/:handle
# No authentication required — fully public.

class ProfilesController < ApplicationController
  layout false

  def show
    @profile   = CivicProfile.find_by!(provider_handle: params[:handle])
    @portfolio = @profile.library_items
                         .where("? = ANY(tags)", "portfolio")
                         .where(visibility: LibraryItem.visibilities[:public])
                         .order(created_at: :desc)
    @temple_item = @profile.library_items
                            .where("? = ANY(tags)", "temple")
                            .where(visibility: LibraryItem.visibilities[:public])
                            .order(created_at: :desc)
                            .first
  rescue ActiveRecord::RecordNotFound
    render file: Rails.root.join("public/404.html"), status: :not_found, layout: false
  end
end
