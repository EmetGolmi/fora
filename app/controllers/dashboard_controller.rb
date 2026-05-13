require 'ostruct'

class DashboardController < ApplicationController
  def index
  end

  # GET /dashboard
  # Session-based dashboard: reads session[:dashboard_job_id] set by #result.
  # No login — the address IS the identity.
  def show
    job_id = session[:dashboard_job_id]
    if job_id.blank?
      redirect_to root_path
      return
    end

    cached = Rails.cache.read("resolve:#{job_id}") ||
             ResolvedAddress.find_by(job_id: job_id)&.result_json

    if cached.blank?
      session.delete(:dashboard_job_id)
      redirect_to root_path, alert: "Session expired. Please search again."
      return
    end

    data = JSON.parse(cached, symbolize_names: true)

    if data[:error].present?
      redirect_to root_path, alert: "Could not resolve address. Please try again."
      return
    end

    @address      = data[:address]
    @jurisdiction = data[:jurisdiction]
    @today        = Date.today

    otd_entries          = OnThisDayEntry.for_today
    @on_this_day_event   = otd_entries.events.order(is_featured: :desc, year: :desc).first
    @on_this_day_birth   = otd_entries.births.order(is_featured: :desc, year: :desc).first

    @rcos = begin
      lat = @jurisdiction[:lat]
      lng = @jurisdiction[:lng]
      if lat.present? && lng.present? && @jurisdiction[:city].to_s.upcase == "PHILADELPHIA"
        PhillyRcoService.for_coordinate(lat, lng)
      else
        []
      end
    rescue StandardError
      []
    end

    date_filter      = ["status_date >= ? OR status_date IS NULL", Date.new(2025, 1, 1)]
    docket_scope     = CivicBill.active.where(date_filter).order(status_date: :desc)
    record_scope     = CivicBill.resolved.order(status_date: :desc)
    @docket_total    = docket_scope.count
    @record_total    = record_scope.count
    @docket_bills    = docket_scope.limit(18).to_a
    @record_bills    = record_scope.limit(18).to_a
    @docket_has_more = @docket_total > 18
    @record_has_more = @record_total > 18
  end

  # GET /dashboard/clear
  # Change Address button: clears session and returns to address entry.
  def clear
    session.delete(:dashboard_job_id)
    redirect_to root_path
  end

  def resolve
    address = params[:address].to_s.strip
    if address.blank?
      render json: { error: "Address is required" }, status: :unprocessable_entity
      return
    end

    job_id = SecureRandom.uuid
    Rails.cache.write("address:#{job_id}", address, expires_in: 10.minutes)
    ResolveAddressJob.perform_later(address, job_id)

    render json: { job_id: job_id }
  end

  def status
    job_id = params[:job_id]
    cached = Rails.cache.read("resolve:#{job_id}") ||
             ResolvedAddress.find_by(job_id: job_id)&.result_json

    if cached.present?
      render json: { ready: true, redirect: "/dashboard/result/#{job_id}" }
    else
      render json: { ready: false }
    end
  end

  # GET /dashboard/result/:job_id
  # One-time redirect: seeds session and sends to persistent /dashboard URL.
  def result
    job_id = params[:job_id]
    cached = Rails.cache.read("resolve:#{job_id}") ||
             ResolvedAddress.find_by(job_id: job_id)&.result_json

    if cached.blank?
      redirect_to root_path, alert: "Session expired. Please search again."
      return
    end

    data = JSON.parse(cached, symbolize_names: true)

    if data[:error].present?
      redirect_to root_path, alert: "Could not resolve address. Please try again."
      return
    end

    session[:dashboard_job_id] = job_id
    redirect_to dashboard_path
  end

  def bills
    view        = params[:view] == 'record' ? 'record' : 'docket'
    offset      = [params[:offset].to_i, 0].max
    date_filter = ["status_date >= ? OR status_date IS NULL", Date.new(2025, 1, 1)]

    scope = if view == 'record'
      CivicBill.resolved.where(date_filter)
    else
      CivicBill.active.where(date_filter)
    end.order(status_date: :desc)

    bills    = scope.offset(offset).limit(18)
    has_more = scope.offset(offset + 18).exists?

    render json: {
      bills: bills.map { |b|
        {
          id:           b.id,
          identifier:   b.identifier,
          title:        b.title,
          status:       b.status,
          status_date:  b.status_date&.strftime('%b %d, %Y'),
          jurisdiction: b.jurisdiction
        }
      },
      has_more: has_more
    }
  end
end
