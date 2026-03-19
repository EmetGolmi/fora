class DashboardController < ApplicationController
  def index
  end

  def show
    address = params[:address]

    if address.blank?
      redirect_to root_path, alert: "Please enter an address."
      return
    end

    @address = address
    @jurisdiction = JurisdictionResolver.resolve(address)
    @state_bills = CivicBill.where(jurisdiction: "pennsylvania").order(created_at: :desc).limit(3)
    @federal_bills = CivicBill.where(jurisdiction: "federal").order(created_at: :desc).limit(3)
  end
end
