class UpdateDavisPhoto < ActiveRecord::Migration[8.1]
  def up
    Person.find_by(slug: "adavis-pa-ltgov")&.update!(
      photo_url: "https://s7d9.scene7.com/is/image/statepa/Lt_Gov_Austin_Davis?ts=1747949551140&dpr=off"
    )
  end

  def down
    Person.find_by(slug: "adavis-pa-ltgov")&.update!(
      photo_url: "https://www.ltgov.pa.gov/wp-content/uploads/sites/175/2023/01/Davis-Official-Headshot.jpg"
    )
  end
end
