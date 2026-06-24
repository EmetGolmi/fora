class BillReflectionsController < ApplicationController
  before_action :require_profile
  before_action :set_bill

  # POST /mvp/bills/:bill_id/reflection
  # Upsert: one reflection per profile+bill. Merges supplied fields only.
  def upsert
    reflection = @profile.bill_reflections.find_or_initialize_by(civic_bill: @bill)
    reflection.assign_attributes(reflection_params)

    if reflection.save
      render json: { ok: true, id: reflection.id }
    else
      render json: { ok: false, errors: reflection.errors.full_messages },
             status: :unprocessable_entity
    end
  end

  # POST /mvp/bills/:bill_id/tone_check
  # Stateless advisory check. Result is NEVER stored.
  def tone_check
    draft = params[:draft].to_s.strip
    result = ToneInterceptService.check(draft)
    render json: result
  end

  private

  def require_profile
    @profile = current_user&.civic_profile
    unless @profile
      render json: { ok: false, error: "sign in required" }, status: :unauthorized
    end
  end

  def set_bill
    @bill = CivicBill.find_by(id: params[:bill_id])
    unless @bill
      render json: { ok: false, error: "bill not found" }, status: :not_found
    end
  end

  def reflection_params
    p = params.permit(:reaction_note, :steelman_note, feeling_tags: [])
    # Coerce feeling_tags from JSON string if sent that way
    if p[:feeling_tags].is_a?(String)
      p[:feeling_tags] = JSON.parse(p[:feeling_tags]) rescue []
    end
    p
  end
end
