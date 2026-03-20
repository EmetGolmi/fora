Rails.application.config.after_initialize do
  if Rails.env.production?
    begin
      if ActiveRecord::Base.connection.table_exists?(:civic_bills)
        if CivicBill.where(jurisdiction: "pennsylvania").count.zero?
          CivicSyncService.sync_pennsylvania_bills
        end

        if CivicBill.where(jurisdiction: "federal").count.zero?
          CongressBillsService.sync_federal_bills
        end

        if CivicBill.where(jurisdiction: "philadelphia").count.zero?
          PhillyBillsService.sync_philly_bills
        end
      end
    rescue => e
      Rails.logger.error("sync_bills initializer failed: #{e.message}")
    end
  end
end
