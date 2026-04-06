class ClearResolvedAddressCache < ActiveRecord::Migration[8.1]
  def up
    # Clear stale cached address results so all dashboards pick up
    # newly-added appointed officials (Thiel, Dubow) on next lookup.
    execute "TRUNCATE TABLE resolved_addresses"
  end

  def down
    # No-op: cache data is ephemeral
  end
end
