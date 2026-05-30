class IjdbFoiaRequestsController < ApplicationController
  def new
    @city    = params[:city].to_s.downcase
    @country = "usa"
    entry_id = params[:entry_id]
    @entry   = entry_id.present? ? IjdbEntry.find_by(id: entry_id) : nil
    @request = IjdbFoiaRequest.new(city: @city, ijdb_entry: @entry)
  end

  def create
    @city    = params[:city].to_s.downcase
    @country = "usa"
    @request = IjdbFoiaRequest.new(foia_params.merge(city: @city))

    if @request.save
      redirect_to city_ijdb_path(city: @city),
                  notice: "FOIA request drafted. Download your letter below."
    else
      @entry = @request.ijdb_entry
      render :new, status: :unprocessable_entity
    end
  end

  private

  def foia_params
    params.require(:ijdb_foia_request).permit(
      :ijdb_entry_id, :requester_name, :agency, :topic_key,
      :letter_text, :status
    )
  end
end
