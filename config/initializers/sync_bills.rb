Rails.application.config.after_initialize do
  if Rails.env.production?
    Thread.new do
      sleep 15
      begin
        if ActiveRecord::Base.connection.table_exists?(:civic_bills)
          count = CivicBill.where(jurisdiction: ["pennsylvania", "federal", "philadelphia"]).where(bill_stage: nil).count
          if count > 0
            Rails.logger.info "[FORA] Running bill_stage backfill for #{count} bills..."
            OpenStatesService.backfill_status
            Rails.logger.info "[FORA] Backfill complete: #{CivicBill.group(:bill_stage).count}"
          end
        end
      rescue => e
        Rails.logger.error "[FORA] Backfill failed: #{e.message}"
      end
    end
  end
end
