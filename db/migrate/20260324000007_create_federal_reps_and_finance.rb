class CreateFederalRepsAndFinance < ActiveRecord::Migration[8.1]
  def up
    reps = [
      { name: "John Fetterman", bioguide: "F000479", office: "U.S. Senator", party: "Democratic",
        jurisdiction: "federal", source: "hardcoded", external_id: "bioguide:F000479",
        fec_id: "S6PA00274", raised: 159_156_753, spent: 195_775_628, cash: 194_849_784,
        indiv: 142_777_590, pac: 1_750_000, debts: 3_789_948, coverage: "2025-12-31" },
      { name: "Dave McCormick",  bioguide: "M001243", office: "U.S. Senator", party: "Republican",
        jurisdiction: "federal", source: "hardcoded", external_id: "bioguide:M001243",
        fec_id: "S2PA00661", raised: 348_681_286, spent: 325_926_723, cash: 83_302_351,
        indiv: 187_113_238, pac: 50_350_000, debts: 2_114_869_672, coverage: "2025-12-31" },
      { name: "Dwight Evans",    bioguide: "E000296", office: "U.S. Representative", party: "Democratic",
        jurisdiction: "federal", source: "hardcoded", external_id: "bioguide:E000296",
        fec_id: "H6PA02171", raised: 23_384_415, spent: 26_562_566, cash: 4_435_568,
        indiv: 12_610_134, pac: 10_750_000, debts: 0, coverage: "2025-12-31" }
    ]

    reps.each do |r|
      rep = CivicRepresentative.find_or_create_by!(name: r[:name]) do |cr|
        cr.office        = r[:office]
        cr.party         = r[:party]
        cr.jurisdiction  = r[:jurisdiction]
        cr.source        = r[:source]
        cr.external_id   = r[:external_id]
        cr.external_ids  = { "bioguide_id" => r[:bioguide] }
      end

      # Ensure external_ids has bioguide_id even if record pre-existed
      unless rep.external_ids["bioguide_id"] == r[:bioguide]
        rep.update_columns(external_ids: rep.external_ids.merge("bioguide_id" => r[:bioguide]))
      end

      OfficialFinanceSummary.find_or_create_by!(civic_representative_id: rep.id, cycle_year: 2026) do |f|
        f.fec_candidate_id         = r[:fec_id]
        f.total_raised_cents       = r[:raised]
        f.total_spent_cents        = r[:spent]
        f.cash_on_hand_cents       = r[:cash]
        f.individual_contrib_cents = r[:indiv]
        f.pac_contrib_cents        = r[:pac]
        f.debts_owed_cents         = r[:debts]
        f.coverage_through_date    = r[:coverage]
        f.data_source              = "fec_weball26"
      end

      Rails.logger.info "[FORA] Created/found rep #{rep.name} (id=#{rep.id}), finance record created"
    end
  end

  def down
    %w[John\ Fetterman Dave\ McCormick Dwight\ Evans].each do |name|
      rep = CivicRepresentative.find_by(name: name)
      next unless rep
      OfficialFinanceSummary.where(civic_representative_id: rep.id).destroy_all
      rep.destroy if rep.source == "hardcoded"
    end
  end
end
