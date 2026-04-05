class UpdateShapiroPhoto < ActiveRecord::Migration[8.1]
  NEW_URL = "https://www.nga.org/wp-content/uploads/2023/01/JDS_headshot.png".freeze

  def up
    Person.where(slug: "jshapiro-pa-gov").update_all(photo_url: NEW_URL)
  end

  def down
    Person.where(slug: "jshapiro-pa-gov")
          .update_all(photo_url: "https://www.governor.pa.gov/wp-content/uploads/2023/01/Shapiro-Official-Portrait.jpg")
  end
end
