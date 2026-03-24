class GovtrackService
  HARDCODED_STATS = {
    "F000479" => { party_vote_pct: 68.0, missed_votes_pct: 13.9, committees: [] },
    "M001243" => { party_vote_pct: 95.0, missed_votes_pct:  2.8, committees: [] },
    "E000296" => { party_vote_pct: 96.0, missed_votes_pct:  8.1, committees: [] },
    "B001296" => { party_vote_pct: 97.0, missed_votes_pct:  5.2, committees: [] }
  }.freeze

  def self.fetch(bioguide_id)
    HARDCODED_STATS[bioguide_id] || {}
  end
end
