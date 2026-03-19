class CivicSyncService
  def self.sync_pennsylvania_bills
    new.sync_pennsylvania_bills
  end

  def sync_pennsylvania_bills
    bills = OpenStatesService.new.pennsylvania_bills
    synced = 0
    failed = 0

    bills.each do |bill|
      attributes = bill.merge(jurisdiction: "pennsylvania")
      CivicBill.upsert(attributes, unique_by: [:source, :external_id])
      synced += 1
    rescue => e
      Rails.logger.error("CivicSyncService: failed to sync bill #{bill[:external_id]}: #{e.message}")
      failed += 1
    end

    { synced: synced, failed: failed }
  end
end
