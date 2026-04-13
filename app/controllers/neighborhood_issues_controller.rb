class NeighborhoodIssuesController < ApplicationController
  before_action :set_rco_slug

  def index
    @issues = NeighborhoodIssue
      .where(rco_slug: @rco_slug)
      .order(created_at: :desc)
      .includes(:issue_responses, :issue_concurrences)
    render json: @issues.map { |i| issue_json(i) }
  end

  def create
    @issue = NeighborhoodIssue.new(issue_params)
    @issue.rco_slug = @rco_slug
    @issue.anonymous = params[:anonymous] == 'true'
    if @issue.save
      render json: issue_json(@issue), status: :created
    else
      render json: { errors: @issue.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def concur
    @issue = NeighborhoodIssue.find(params[:id])
    token = session_token
    concurrence = @issue.issue_concurrences.find_or_initialize_by(session_token: token)
    if concurrence.new_record?
      concurrence.save!
      @issue.increment!(:concurrence_count)
      if @issue.threshold_reached? && !@issue.ccra_alerted?
        @issue.update!(ccra_alerted: true)
        # Future: send alert email to RCO here
      end
    end
    render json: issue_json(@issue)
  end

  private

  def set_rco_slug
    @rco_slug = params[:rco_slug]
  end

  def issue_params
    params.require(:neighborhood_issue).permit(
      :body, :perspective_type, :author_name,
      :author_email, :location_description,
      :photo_data, :photo_url, :photo_filename
    )
  end

  def session_token
    session[:civic_token] ||= SecureRandom.hex(16)
  end

  def issue_json(issue)
    {
      id: issue.id,
      body: issue.body,
      perspective_type: issue.perspective_type,
      perspective_label: NeighborhoodIssue::PERSPECTIVE_LABELS[issue.perspective_type],
      display_author: issue.display_author,
      location_description: issue.location_description,
      concurrence_count: issue.concurrence_count,
      alert_threshold: issue.alert_threshold,
      remaining_concurrences: issue.remaining_concurrences,
      progress_percent: issue.progress_percent,
      threshold_reached: issue.threshold_reached?,
      ccra_alerted: issue.ccra_alerted?,
      share_text_issue: issue.share_text_issue,
      share_text_recruit: issue.share_text_recruit,
      share_text_alerted: issue.share_text_alerted,
      photo_src: issue.photo_src,
      photo_filename: issue.photo_filename,
      has_photo: issue.has_photo?,
      created_at: issue.created_at.strftime('%B %d at %l:%M %p'),
      responses: issue.issue_responses.order(created_at: :asc).map { |r|
        {
          id: r.id,
          body: r.body,
          perspective_type: r.perspective_type,
          perspective_label: NeighborhoodIssue::PERSPECTIVE_LABELS[r.perspective_type],
          display_author: r.display_author,
          official: r.official?,
          concurrence_count: r.concurrence_count,
          photo_src: r.photo_src,
          photo_filename: r.photo_filename,
          has_photo: r.has_photo?,
          created_at: r.created_at.strftime('%B %d at %l:%M %p')
        }
      }
    }
  end
end
