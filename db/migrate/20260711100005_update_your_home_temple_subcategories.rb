class UpdateYourHomeTempleSubcategories < ActiveRecord::Migration[8.1]
  def up
    domain = TempleDomain.find_by!(slug: 'tpl-your-home')
    domain.temple_subcategories.delete_all
    [
      { slug: 'maint-repair',   name: 'Maintenance & Repair', position: 1 },
      { slug: 'housing-rights', name: 'Housing Rights',        position: 2 },
      { slug: 'home-wellness',  name: 'Home Wellness',         position: 3 },
      { slug: 'what-makes-home',name: "What Makes a Home?",   position: 4 },
    ].each { |s| TempleSubcategory.create!(temple_domain: domain, **s) }
  end

  def down
    domain = TempleDomain.find_by!(slug: 'tpl-your-home')
    domain.temple_subcategories.delete_all
    [
      { slug: 'tenant-rights',        name: 'Tenant Rights',          position: 1 },
      { slug: 'homeowner-rights',     name: 'Homeowner Rights',       position: 2 },
      { slug: 'hoa-condo-law',        name: 'HOA & Condo Law',        position: 3 },
      { slug: 'historic-preservation',name: 'Historic Preservation',  position: 4 },
      { slug: 'home-safety-guides',   name: 'Home Safety Guides',     position: 5 },
      { slug: 'environmental-hazards',name: 'Environmental Hazards',  position: 6 },
    ].each { |s| TempleSubcategory.create!(temple_domain: domain, **s) }
  end
end
