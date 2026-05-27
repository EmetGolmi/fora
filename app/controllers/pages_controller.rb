class PagesController < ApplicationController
  def about
  end

  def mc
    data_path = Rails.root.join('app/data/mc_communities.json')
    @communities = JSON.parse(File.read(data_path))
  end
end
