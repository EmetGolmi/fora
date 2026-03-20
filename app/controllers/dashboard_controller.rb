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

    render :show
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
