class ForumCommentsController < ApplicationController
  def index
    bill_num = params[:bill_num].to_s.strip
    return render json: [] if bill_num.blank?

    comments = ForumComment.for_bill(bill_num).limit(50)
    render json: comments.map { |c|
      {
        id:         c.id,
        handle:     c.display_handle,
        body:       c.body,
        created_at: c.created_at.strftime("%b %-d, %Y")
      }
    }
  end

  def create
    bill_num = params[:bill_num].to_s.strip
    body     = params[:body].to_s.strip
    handle   = current_user&.handle || params[:handle].to_s.strip.presence || "Anonymous"

    comment = ForumComment.new(
      bill_num: bill_num,
      body:     body,
      user_id:  current_user&.id,
      handle:   handle
    )

    if comment.save
      render json: {
        ok:         true,
        id:         comment.id,
        handle:     comment.display_handle,
        body:       comment.body,
        created_at: comment.created_at.strftime("%b %-d, %Y")
      }
    else
      render json: { ok: false, errors: comment.errors.full_messages },
             status: :unprocessable_entity
    end
  end
end
