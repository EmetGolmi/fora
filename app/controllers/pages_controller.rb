class PagesController < ApplicationController
  # GET / — logged-in users bounce to dashboard; everyone else sees the landing page.
  def landing
    return redirect_to dashboard_path if current_user
    render layout: false
  end

  def about
  end

  def mc
    data_path = Rails.root.join('app/data/mc_communities.json')
    @communities = JSON.parse(File.read(data_path))
  end

  def israel_sanctuary
    data_path = Rails.root.join('app', 'data', 'mc_communities.json')
    @communities = JSON.parse(File.read(data_path))
    @israel_communities = @communities.select { |c|
      c['israel_connection'] && c['israel_connection'] != 'No direct community in Israel' &&
      !c['israel_connection'].start_with?('No direct') &&
      !c['israel_connection'].start_with?('No indigenous')
    }
  end
end
