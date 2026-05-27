## WHAT HAPPENED
The vote page (app/views/vote/may19.html.erb) was accidentally
stripped down to almost nothing by a previous command. We are
restoring it now.

## STEP 1 — Read what's currently broken
  wc -l app/views/vote/may19.html.erb
  head -3 app/views/vote/may19.html.erb

## STEP 2 — Replace the file
Copy this exact file into app/views/vote/may19.html.erb:
  [drop may19.html.erb here]

Do not run any Ruby on it. Do not strip anything. Write as-is.

## STEP 3 — Update VoteController
Replace app/controllers/vote_controller.rb with:

  class VoteController < ApplicationController
    def may19
      # Polling place comes from the user's session,
      # set when they looked up their address on the dashboard.
      # Falls back to a prompt to enter their address.
      @polling_place_name    = session[:polling_place_name]    ||
                               "Enter your address on the dashboard"
      @polling_place_address = session[:polling_place_address] ||
                               "to find your polling place"
      render 'vote/may19'
    end
  end

## STEP 4 — Verify it loads
  curl -s -o /dev/null -w "%{http_code}" http://localhost:3000/votemay19
  → must return 200

## STEP 5 — Commit and push
  git add app/views/vote/may19.html.erb app/controllers/vote_controller.rb
  git commit -m "votemay19 — restored vote guide, dynamic polling place from session"
  git push origin main
