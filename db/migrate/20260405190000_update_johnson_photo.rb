class UpdateJohnsonPhoto < ActiveRecord::Migration[8.1]
  def up
    Person.find_by(slug: 'kjohnson-phl-d2')&.update!(
      photo_url: 'https://phlcouncil.com/wp-content/uploads/2025/04/CP_Johnson_Close__RED_TIE__up1-e1744149308872.jpg'
    )
  end

  def down
    Person.find_by(slug: 'kjohnson-phl-d2')&.update!(photo_url: nil)
  end
end
