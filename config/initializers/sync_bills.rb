Rails.application.config.after_initialize do
  if Rails.env.production?
    begin
      if ActiveRecord::Base.connection.table_exists?(:civic_bills) && CivicBill.count.zero?
        CivicSyncService.sync_pennsylvania_bills
      end
    rescue => e
      Rails.logger.error("sync_bills initializer failed: #{e.message}")
    end
  end
end
