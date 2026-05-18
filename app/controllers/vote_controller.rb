class VoteController < ApplicationController
  def may19
    @polling_place_name    = session[:polling_place_name]    || 'Enter your address on the dashboard'
    @polling_place_address = session[:polling_place_address] || 'to find your polling place'
    render 'vote/may19'
  end

  def cast
    ward     = session[:ward]     || params[:ward]     || '0'
    division = session[:division] || params[:division] || '0'
    zip      = session[:zip_code] || params[:zip_code]

    token_hash = Digest::SHA256.hexdigest(
      request.session.id.to_s + PreBallot::ELECTION_SLUG
    )

    pb = PreBallot.find_or_initialize_by(
      session_token_hash: token_hash,
      election_slug:      PreBallot::ELECTION_SLUG
    )

    pb.assign_attributes(
      ward:         ward,
      division:     division,
      zip_code:     zip,
      governor:     params[:governor],
      lt_governor:  params[:lt_governor],
      us_rep:       params[:us_rep],
      pa_state_rep: params[:pa_state_rep],
      ballot_q1:    params[:ballot_q1],
      ballot_q2:    params[:ballot_q2]
    )

    if pb.save
      session[:preballot_governor]     = params[:governor]
      session[:preballot_lt_governor]  = params[:lt_governor]
      session[:preballot_us_rep]       = params[:us_rep]
      session[:preballot_pa_state_rep] = params[:pa_state_rep]
      session[:preballot_q1]           = params[:ballot_q1]
      session[:preballot_q2]           = params[:ballot_q2]
      render json: { success: true }
    else
      render json: { success: false, errors: pb.errors.full_messages },
             status: :unprocessable_entity
    end
  end

  def results
    @ward     = session[:ward]     || '1'
    @division = session[:division] || '8'
    @polling_place_name    = session[:polling_place_name]    || 'Your Polling Place'
    @polling_place_address = session[:polling_place_address] || ''

    @div_count  = PreBallot.division_count(@ward, @division)
    @ward_count = PreBallot.ward_count(@ward)
    @city_count = PreBallot.city_count

    if @div_count >= PreBallot::MIN_DIVISION_COUNT
      @race_data = PreBallot::RACES.index_with do |race|
        PreBallot.race_breakdown(@ward, @division, race)
      end
    else
      @race_data = {}
      @too_few   = true
    end

    @ward_divisions = PreBallot.ward_division_breakdown(@ward)

    @my_selections = {
      governor:     session[:preballot_governor],
      lt_governor:  session[:preballot_lt_governor],
      us_rep:       session[:preballot_us_rep],
      pa_state_rep: session[:preballot_pa_state_rep],
      ballot_q1:    session[:preballot_q1],
      ballot_q2:    session[:preballot_q2]
    }

    render 'vote/results'
  end
end
