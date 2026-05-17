namespace :bills do
  desc "Re-fetch OpenStates PA bills to populate raw_data, session_identifier, and summary"
  task backfill_openstates: :environment do
    service = OpenStatesService.new
    bills   = CivicBill.where(source: "openstates", jurisdiction: "pennsylvania")
    total   = bills.count
    puts "Re-fetching #{total} OpenStates PA bills..."
    ok = 0
    errors = 0
    bills.each do |bill|
      begin
        service.refresh_bill(bill)
        ok += 1
        print "."
      rescue => e
        errors += 1
        print "E"
        Rails.logger.error("backfill_openstates: bill #{bill.id} (#{bill.identifier}) failed — #{e.message}")
      end
    end
    puts "\nDone. #{ok} refreshed, #{errors} errors."
  end
end
