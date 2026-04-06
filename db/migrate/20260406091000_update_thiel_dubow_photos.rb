class UpdateThielDubowPhotos < ActiveRecord::Migration[8.1]
  def up
    Person.find_by(slug: 'athiel-philly-md')&.update!(
      photo_url: 'https://www.phila.gov/media/20240206114037/Adam-Thiel-bio-pic.jpg'
    )

    Person.find_by(slug: 'rdubow-philly-finance')&.update!(
      photo_url: 'https://www.inquirer.com/resizer/v2/RWNGFQHM5VGNROKKTJCZA7SDTI.jpg?auth=3ec3779e30f0334b61a46e030aeecb7268e5f6cfaab7584c251617bc350affb7&width=760&height=507&smart=true'
    )
  end

  def down
    Person.find_by(slug: 'athiel-philly-md')&.update!(photo_url: nil)
    Person.find_by(slug: 'rdubow-philly-finance')&.update!(photo_url: nil)
  end
end
