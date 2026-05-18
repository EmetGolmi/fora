class CreatePreBallots < ActiveRecord::Migration[8.1]
  def change
    create_table :pre_ballots do |t|
      t.string  :ward,               null: false
      t.string  :division,           null: false
      t.string  :zip_code
      t.string  :election_slug,      null: false, default: 'pa_primary_20260519'
      t.string  :governor
      t.string  :lt_governor
      t.string  :us_rep
      t.string  :pa_state_rep
      t.string  :ballot_q1
      t.string  :ballot_q2
      t.string  :session_token_hash, null: false
      t.timestamps
    end

    add_index :pre_ballots, [:session_token_hash, :election_slug],
              unique: true, name: 'idx_preballot_session_election'
    add_index :pre_ballots, [:ward, :division, :election_slug],
              name: 'idx_preballot_geography'
    add_index :pre_ballots, [:election_slug],
              name: 'idx_preballot_election'
  end
end
