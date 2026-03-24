class GovtrackService
  HARDCODED_STATS = {
    "F000479" => { party_vote_pct: 68.0, missed_votes_pct: 13.9, votes_cast: "~1,205 of ~1,400", chamber_avg_attendance: 93.0, chamber_avg_party: 88.0, committees: [] },
    "M001243" => { party_vote_pct: 95.0, missed_votes_pct:  2.8, votes_cast: "~1,361 of ~1,400", chamber_avg_attendance: 93.0, chamber_avg_party: 88.0, committees: [] },
    "E000296" => { party_vote_pct: 96.0, missed_votes_pct: 14.8, votes_cast: "~1,150 of ~1,350", chamber_avg_attendance: 95.0, chamber_avg_party: 92.0, committees: [] },
    "B001296" => { party_vote_pct: 97.0, missed_votes_pct:  5.2, votes_cast: "~1,280 of ~1,350", chamber_avg_attendance: 95.0, chamber_avg_party: 92.0, committees: [] }
  }.freeze

  def self.fetch(bioguide_id)
    HARDCODED_STATS[bioguide_id] || {}
  end
end
