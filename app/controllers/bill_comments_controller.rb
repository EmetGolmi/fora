class BillCommentsController < ApplicationController
  before_action :set_bill
  before_action :set_session_token

  def index
    @comments = @bill.bill_comments
                     .public_visible
                     .most_recent
                     .limit(50)
    render json: @comments.map { |c|
      {
        id:               c.id,
        stance:           c.stance,
        perspective_type: c.perspective_type,
        body:             c.body,
        display_name:     c.display_name,
        anonymous:        c.anonymous,
        link_url:         c.link_url,
        created_at:       c.created_at.strftime("%B %-d, %Y"),
        is_mine:          c.session_token == @session_token
      }
    }
  end

  def create
    @comment = @bill.bill_comments.new(comment_params)
    @comment.session_token = @session_token

    if @comment.save
      render json: {
        success: true,
        comment: {
          id:               @comment.id,
          stance:           @comment.stance,
          perspective_type: @comment.perspective_type,
          body:             @comment.body,
          display_name:     @comment.display_name,
          anonymous:        @comment.anonymous,
          link_url:         @comment.link_url,
          created_at:       @comment.created_at.strftime("%B %-d, %Y"),
          is_mine:          true
        }
      }, status: :created
    else
      render json: { success: false, errors: @comment.errors.full_messages },
             status: :unprocessable_entity
    end
  end

  private

  def set_bill
    @bill = CivicBill.find(params[:bill_id])
  end

  def set_session_token
    session[:civic_token] ||= SecureRandom.hex(16)
    @session_token = session[:civic_token]
  end

  def comment_params
    params.require(:bill_comment).permit(
      :stance, :perspective_type, :body, :occupation, :anonymous, :photo_url, :link_url
    )
  end
end
