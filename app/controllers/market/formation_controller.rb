# app/controllers/market/formation_controller.rb
module Market
  class FormationController < ApplicationController
    before_action :set_track, only: [:show, :toggle_step]

    # GET /market/formation
    def index
      @tracks = FormationTrack.where(is_published: true).order(:name)
    end

    # GET /market/formation/:id
    def show
      @steps_by_phase = @track.formation_steps
                               .order(:display_order)
                               .group_by(&:phase)

      @progress = if current_user
        UserFormationProgress
          .where(user: current_user, track_id: @track.id)
          .index_by { |p| p.step_id.to_s }
      else
        {}
      end

      @done_count  = @progress.count { |_, p| p.status_done? }
      @total_steps = @track.formation_steps.count

      @definitions = Definition.all.index_by { |d| d.term.downcase }
    end

    # PATCH /market/formation/:id/toggle_step
    def toggle_step
      return render json: { error: "login required" }, status: :unauthorized unless current_user

      step = FormationStep.find(params[:step_id])
      prog = UserFormationProgress.find_or_initialize_by(
        user_id:  current_user.id,
        track_id: @track.id,
        step_id:  step.id
      )

      if prog.status_done?
        prog.update!(status: :not_started, completed_at: nil)
      else
        prog.update!(status: :done, completed_at: Time.current)
      end

      render json: {
        step_id: step.id,
        status:  prog.status,
        done:    prog.status_done?
      }
    end

    private

    def set_track
      @track = FormationTrack.find(params[:id])
    end
  end
end
