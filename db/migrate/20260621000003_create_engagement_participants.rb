class CreateEngagementParticipants < ActiveRecord::Migration[8.1]
  def change
    create_table :engagement_participants do |t|
      t.references :engagement,    null: false, foreign_key: true
      t.references :civic_profile, null: false, foreign_key: true
      t.string     :role,          null: false   # free text: "Inspector", "Client", "Realtor"

      t.timestamps
    end

    # One profile can't hold the same role twice on the same engagement
    add_index :engagement_participants,
              [ :engagement_id, :civic_profile_id, :role ],
              unique: true,
              name: "idx_eng_participants_unique"
  end
end
