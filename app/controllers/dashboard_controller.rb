require 'ostruct'

class DashboardController < ApplicationController
  def index
  end

  def show
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
    cached = Rails.cache.read("resolve:#{job_id}")

    if cached.present?
      render json: { ready: true, redirect: "/dashboard/result/#{job_id}" }
    else
      render json: { ready: false }
    end
  end

  def result
    job_id = params[:job_id]
    cached = Rails.cache.read("resolve:#{job_id}")

    if cached.blank?
      redirect_to root_path, alert: "Session expired. Please search again."
      return
    end

    data = JSON.parse(cached, symbolize_names: true)

    if data[:error].present?
      redirect_to root_path, alert: "Could not resolve address. Please try again."
      return
    end

    @address       = data[:address]
    @jurisdiction  = data[:jurisdiction]
    @state_bills   = bills_from_cache(data[:state_bills])
    @federal_bills = bills_from_cache(data[:federal_bills])
    @philly_bills  = bills_from_cache(data[:philly_bills])

    date_filter      = ["status_date >= ? OR status_date IS NULL", Date.new(2025, 1, 1)]
    docket_scope     = CivicBill.active.where(date_filter).order(status_date: :desc)
    record_scope     = CivicBill.resolved.where(date_filter).order(status_date: :desc)
    @docket_total    = docket_scope.count
    @record_total    = record_scope.count
    @docket_bills    = docket_scope.limit(18).to_a
    @record_bills    = record_scope.limit(18).to_a
    @docket_has_more = @docket_total > 18
    @record_has_more = @record_total > 18

    render :show
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

  private

  def bills_from_cache(arr)
    (arr || []).map do |b|
      b = b.dup
      b[:status_date] = Date.parse(b[:status_date].to_s) if b[:status_date].present?
      OpenStruct.new(b)
    end
  end
end
