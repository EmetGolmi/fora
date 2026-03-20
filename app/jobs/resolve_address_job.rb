class ResolveAddressJob < ApplicationJob
  queue_as :default

  def perform(address, job_id)
    jurisdiction = JurisdictionResolver.resolve(address)

    state_bills   = CivicBill.where(jurisdiction: "pennsylvania").order(created_at: :desc).limit(3).as_json
    federal_bills = CivicBill.where(jurisdiction: "federal").order(created_at: :desc).limit(3).as_json
    philly_bills  = CivicBill.where(jurisdiction: "philadelphia").order(created_at: :desc).limit(3).as_json

    result = {
      address: address,
      jurisdiction: jurisdiction,
      state_bills: state_bills,
      federal_bills: federal_bills,
      philly_bills: philly_bills
    }

    Rails.cache.write("resolve:#{job_id}", result.to_json, expires_in: 10.minutes)
  rescue => e
    Rails.cache.write("resolve:#{job_id}", { error: e.message }.to_json, expires_in: 10.minutes)
    raise
  end
end
