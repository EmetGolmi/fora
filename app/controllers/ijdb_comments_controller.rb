class IjdbCommentsController < ApplicationController
  def create
    @city    = params[:city].to_s.downcase
    @country = "usa"

    @comment = IjdbComment.new(comment_params.merge(city: @city, country: @country))

    if @comment.save
      redirect_to city_ijdb_path(city: @city), notice: "Comment posted."
    else
      redirect_to city_ijdb_path(city: @city), alert: @comment.errors.full_messages.to_sentence
    end
  end

  private

  def comment_params
    params.require(:ijdb_comment).permit(:body, :author_name, :ijdb_entry_id)
  end
end
