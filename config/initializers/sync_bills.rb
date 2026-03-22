Rails.application.config.after_initialize do
  if Rails.env.production?
    Thread.new do
      sleep 15
      begin
        if ActiveRecord::Base.connection.table_exists?(:civic_bills)
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
