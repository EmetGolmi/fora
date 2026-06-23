class AddProfileToIssueConcurrences < ActiveRecord::Migration[8.1]
  def change
    # Nullable — existing anonymous concurrences (session_token only) stay valid.
    # Logged-in users write civic_profile_id; the constituency meter then joins
    # to civic_profiles.residency_verified to count verified-resident voices.
    # Never stores citizenship or immigration status.
    add_column :issue_concurrences, :civic_profile_id, :bigint

    add_foreign_key :issue_concurrences, :civic_profiles, on_delete: :nullify

    # One concurrence per logged-in profile per issue.
    # Partial index (WHERE NOT NULL) leaves the existing session_token path intact.
    add_index :issue_concurrences,
              [:neighborhood_issue_id, :civic_profile_id],
              unique: true,
              where: "civic_profile_id IS NOT NULL",
              name: "idx_issue_conc_on_issue_and_profile"

    add_index :issue_concurrences, :civic_profile_id,
              name: "idx_issue_concurrences_on_profile"
  end
end
