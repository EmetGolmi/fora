class AddHygieneToTempleHealthBody < ActiveRecord::Migration[8.1]
  def up
    domain = TempleDomain.find_by!(slug: 'tpl-health-body')
    # Shift existing subcategories to open slot at position 1
    domain.temple_subcategories.order(:position).each do |sub|
      sub.update_column(:position, sub.position + 1)
    end
    TempleSubcategory.create!(
      temple_domain: domain,
      name:          'Hygiene',
      slug:          'tpl-hygiene',
      position:      1
    )
  end

  def down
    TempleSubcategory.find_by(slug: 'tpl-hygiene')&.destroy
    domain = TempleDomain.find_by(slug: 'tpl-health-body')
    if domain
      domain.temple_subcategories.order(:position).each_with_index do |sub, i|
        sub.update_column(:position, i + 1)
      end
    end
  end
end
