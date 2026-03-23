namespace :fec do
  desc "Import weball26 pipe-delimited file into official_finance_summaries"
  task import_weball: :environment do
    file_path = Rails.root.join("data", "weball26.txt")

    unless File.exist?(file_path)
      puts "ERROR: #{file_path} not found. Place weball26.txt in the data/ directory."
      exit 1
    end

    cycle_year = 2026
    imported   = 0
    skipped    = 0

    File.foreach(file_path) do |line|
      cols    = line.chomp.split("|")
      cand_id = cols[0]&.strip
      next if cand_id.blank?

      rep = CivicRepresentative.where("external_ids->>'fec_candidate_id' = ?", cand_id).first
      next (skipped += 1) unless rep

      OfficialFinanceSummary.upsert(
        {
          civic_representative_id:   rep.id,
          fec_candidate_id:          cand_id,
          cycle_year:                cycle_year,
          total_raised_cents:        dollars_to_cents(cols[5]),
          total_spent_cents:         dollars_to_cents(cols[7]),
          cash_on_hand_cents:        dollars_to_cents(cols[10]),
          individual_contrib_cents:  dollars_to_cents(cols[17]),
          pac_contrib_cents:         dollars_to_cents(cols[25]),
          candidate_self_fund_cents: dollars_to_cents(cols[11]),
          debts_owed_cents:          dollars_to_cents(cols[16]),
          coverage_through_date:     parse_fec_date(cols[27]),
          data_source:               "fec_weball26",
          updated_at:                Time.current
        },
        unique_by: [:civic_representative_id, :cycle_year]
      )
      imported += 1
    end

    puts "FEC import complete: #{imported} imported, #{skipped} skipped (no official match)"
  end
end

def dollars_to_cents(val)
  return nil if val.blank?
  (val.to_f * 100).round
end

def parse_fec_date(val)
  return nil if val.blank?
  Date.strptime(val.strip, "%m/%d/%Y") rescue nil
end
