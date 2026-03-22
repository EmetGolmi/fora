Rails.application.config.after_initialize do
  if Rails.env.production?
    Thread.new do
      sleep 15
      begin
        if ActiveRecord::Base.connection.table_exists?(:civic_bills)
          newest_federal = CivicBill.where(jurisdiction: "federal").order(created_at: :desc).first
          if newest_federal.nil? || newest_federal.created_at < 7.days.ago
            Rails.logger.info "[FORA] Federal bills stale — running full federal sync..."
            CongressBillsService.sync_federal_bills
          end

          if CivicBill.where(jurisdiction: "pennsylvania").count.zero?
            Rails.logger.info "[FORA] No PA bills — running PA sync..."
            CivicSyncService.sync_pennsylvania_bills
          end

          if CivicBill.where(jurisdiction: "philadelphia").count.zero?
            Rails.logger.info "[FORA] No Philly bills — running Philly sync..."
            PhillyBillsService.sync_philly_bills
          end

          Rails.logger.info "[FORA] Running bill_stage backfill..."
          OpenStatesService.backfill_status
          Rails.logger.info "[FORA] Backfill complete: #{CivicBill.group(:bill_stage).count}"
        end
      rescue => e
        Rails.logger.error "[FORA] Backfill failed: #{e.message}"
      end
    end
  end
end
