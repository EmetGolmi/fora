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

    result_json = result.to_json
    Rails.cache.write("resolve:#{job_id}", result_json, expires_in: 10.minutes)
    ResolvedAddress.upsert(
      { address: address, job_id: job_id, result_json: result_json, created_at: Time.current, updated_at: Time.current },
      unique_by: :address,
      update_only: %i[job_id result_json updated_at]
    )
  rescue => e
    Rails.cache.write("resolve:#{job_id}", { error: e.message }.to_json, expires_in: 10.minutes)
    raise
  end
end
