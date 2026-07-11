class ForumCommentsController < ApplicationController
  def index
    bill_num = params[:bill_num].to_s.strip
    return render json: [] if bill_num.blank?

    comments = ForumComment.for_bill(bill_num).limit(100)
    render json: comments.map { |c|
      {
        id:               c.id,
        handle:           c.display_handle,
        body:             c.body,
        perspective_type: c.perspective_type,
        social_url:       c.social_url,
        created_at:       c.created_at.strftime("%b %-d, %Y")
      }
    }
  end

  def metrics
    bill_num = params[:bill_num].to_s.strip
    return render json: {} if bill_num.blank?

    counts = ForumComment.for_bill(bill_num)
                         .group(:perspective_type)
                         .count
    render json: counts
  end

  def create
    bill_num     = params[:bill_num].to_s.strip
    body         = params[:body].to_s.strip
    perspective  = params[:perspective_type].to_s.strip.presence || "general"
    social_url   = params[:social_url].to_s.strip.presence
    handle       = current_user&.handle || params[:handle].to_s.strip.presence || "Anonymous"

    comment = ForumComment.new(
      bill_num:         bill_num,
      body:             body,
      perspective_type: perspective,
      social_url:       social_url,
      user_id:          current_user&.id,
      handle:           handle
    )

    if comment.save
      render json: {
        ok:               true,
        id:               comment.id,
        handle:           comment.display_handle,
        body:             comment.body,
        perspective_type: comment.perspective_type,
        social_url:       comment.social_url,
        created_at:       comment.created_at.strftime("%b %-d, %Y")
      }
    else
      render json: { ok: false, errors: comment.errors.full_messages },
             status: :unprocessable_entity
    end
  end
end
