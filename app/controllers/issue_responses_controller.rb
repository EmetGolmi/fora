class IssueResponsesController < ApplicationController
  def create
    @issue = NeighborhoodIssue.find(params[:neighborhood_issue_id])
    @response = @issue.issue_responses.new(response_params)
    @response.anonymous = params[:anonymous] == 'true'
    if @response.save
      render json: {
        id: @response.id,
        body: @response.body,
        perspective_type: @response.perspective_type,
        perspective_label: NeighborhoodIssue::PERSPECTIVE_LABELS[@response.perspective_type],
        display_author: @response.display_author,
        official: @response.official?,
        concurrence_count: 0,
        photo_src: @response.photo_src,
        photo_filename: @response.photo_filename,
        has_photo: @response.has_photo?,
        created_at: 'Just now'
      }, status: :created
    else
      render json: { errors: @response.errors.full_messages }, status: :unprocessable_entity
    end
  end

  private

  def response_params
    params.require(:issue_response).permit(
      :body, :perspective_type, :author_name, :author_email,
      :photo_data, :photo_url, :photo_filename
    )
  end
end
