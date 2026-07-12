# ProfilesController
#
# Public provider card at /:locode/:handle (canonical)
# Legacy /p/:handle redirects to canonical via redirect_handle.
# No authentication required — fully public.

class ProfilesController < ApplicationController
  layout false

  def show
    @profile = CivicProfile.find_by!(provider_handle: params[:handle])
    # Redirect to canonical locode URL if the profile's locode differs from the URL
    if @profile.locode.present? && @profile.locode != params[:locode]
      redirect_to "/#{@profile.locode}/#{@profile.provider_handle}", status: :moved_permanently
      return
    end
    load_portfolio
  rescue ActiveRecord::RecordNotFound
    render file: Rails.root.join("public/404.html"), status: :not_found, layout: false
  end

  def redirect_handle
    @profile = CivicProfile.find_by!(provider_handle: params[:handle])
    if @profile.locode.present?
      redirect_to "/#{@profile.locode}/#{@profile.provider_handle}", status: :moved_permanently
    else
      # Unknown city — serve the card directly (no locode yet)
      load_portfolio
      render :show
    end
  rescue ActiveRecord::RecordNotFound
    render file: Rails.root.join("public/404.html"), status: :not_found, layout: false
  end

  private

  def load_portfolio
    @portfolio = @profile.library_items
                         .where("? = ANY(tags)", "portfolio")
                         .where(visibility: LibraryItem.visibilities[:public])
                         .order(created_at: :desc)
    @temple_item = @profile.library_items
                            .where("? = ANY(tags)", "temple")
                            .where(visibility: LibraryItem.visibilities[:public])
                            .order(created_at: :desc)
                            .first
  end
end
