class CandidatesController < ApplicationController
  def chris_rabb
    render 'candidates/chris_rabb'
  end

  def show
    # Future: look up candidate by slug from DB
    # For now, 404 any slug that isn't chris-rabb
    redirect_to root_path
  end
end
