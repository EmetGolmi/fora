class AddPhotosAndClearResolvedAddressCache < ActiveRecord::Migration[8.1]
  def up
    Person.find_by(slug: 'dtrump-us-president')&.update!(
      photo_url: 'https://upload.wikimedia.org/wikipedia/commons/thumb/1/16/Official_Presidential_Portrait_of_President_Donald_J._Trump_%282025%29.jpg/330px-Official_Presidential_Portrait_of_President_Donald_J._Trump_%282025%29.jpg'
    )
    Person.find_by(slug: 'jvance-us-vp')&.update!(
      photo_url: 'https://upload.wikimedia.org/wikipedia/commons/thumb/8/88/Portrait_of_Vice_President_JD_Vance.jpg/330px-Portrait_of_Vice_President_JD_Vance.jpg'
    )
    # Clear stale cached dashboard results — old entries have name:"federal"
    # for president/VP; deleting forces a fresh lookup with the correct names.
    execute "DELETE FROM resolved_addresses"
  end

  def down
    Person.find_by(slug: 'dtrump-us-president')&.update!(photo_url: nil)
    Person.find_by(slug: 'jvance-us-vp')&.update!(photo_url: nil)
  end
end
