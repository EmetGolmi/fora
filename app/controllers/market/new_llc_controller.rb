# app/controllers/market/new_llc_controller.rb

module Market
  class NewLlcController < ApplicationController
    # Skip auth if FORA requires login — this page is public
    # skip_before_action :authenticate_user!, raise: false

    def index
      # Intake form — nothing to set up server-side
    end

    def guide
      # Pass intake params to the view for meta/SEO and
      # progressive enhancement if you ever go server-side.
      # The real personalization happens client-side in JS.
      @name     = params[:name].to_s.strip.truncate(60)
      @work     = params[:work].to_s.strip.truncate(80)
      @location = params[:location].to_s.strip.truncate(80)
      @bank     = params[:bank].to_s.strip.truncate(80)

      # Build a page title from what we know
      @page_title = if @work.present? && @name.present?
        "#{@name}'s #{@work.capitalize} Business Guide · FORA"
      elsif @name.present?
        "#{@name}'s Business Guide · FORA"
      else
        "Start Your Business · FORA"
      end
    end
  end
end
