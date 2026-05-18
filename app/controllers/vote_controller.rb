class VoteController < ApplicationController
  def may19
    @polling_place_name    = session[:polling_place_name]    || "Enter your address on the dashboard"
    @polling_place_address = session[:polling_place_address] || "to find your polling place"
    render 'vote/may19'
  end
end
