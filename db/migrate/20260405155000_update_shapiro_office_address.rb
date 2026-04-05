class UpdateShapiroOfficeAddress < ActiveRecord::Migration[8.1]
  def up
    Person.where(slug: "jshapiro-pa-gov")
          .update_all(office_address: "508 Main Capitol Building · Harrisburg, PA 17120")
  end

  def down
    Person.where(slug: "jshapiro-pa-gov").update_all(office_address: nil)
  end
end
