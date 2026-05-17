namespace :bills do
  desc "Re-fetch OpenStates PA bills to populate raw_data, session_identifier, and summary"
  task backfill_openstates: :environment do
    require "httparty"
    service = OpenStatesService.new
    bills   = CivicBill.where(source: "openstates", jurisdiction: "pennsylvania")
    total   = bills.count
    puts "Re-fetching #{total} OpenStates PA bills (1 request per bill, 1s delay)..."
    ok = 0; errors = 0; rate_limited = 0

    bills.each do |bill|
      begin
        result = service.refresh_bill(bill)
        if result
          ok += 1
          print "."
        else
          errors += 1
          print "?"
          Rails.logger.warn("backfill_openstates: bill #{bill.id} (#{bill.identifier}) — API returned non-success, skipped")
        end
        sleep 1  # stay well under the 250/day quota
      rescue OpenStatesService::RateLimitError => e
        rate_limited += 1
        puts "\n\nRATE LIMITED after #{ok} bills — #{e.message}"
        puts "Quota exhausted for today. Re-run tomorrow."
        break
      rescue => e
        errors += 1
        print "E"
        Rails.logger.error("backfill_openstates: bill #{bill.id} (#{bill.identifier}) — #{e.class}: #{e.message}")
      end
    end

    puts "\nDone. #{ok} refreshed, #{errors} errors, #{rate_limited} rate-limit stops."
    if ok > 0
      with_raw     = CivicBill.where(source: "openstates").where.not(raw_data: nil).count
      with_session = CivicBill.where(source: "openstates").where.not(session_identifier: nil).count
      puts "DB check — raw_data populated: #{with_raw}, session_identifier populated: #{with_session}"
    end
  end
end
