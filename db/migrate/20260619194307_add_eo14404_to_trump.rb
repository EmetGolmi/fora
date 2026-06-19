class AddEo14404ToTrump < ActiveRecord::Migration[8.1]
  def up
    trump = Person.find_by(slug: 'dtrump-us-president')
    return unless trump

    eos = (trump.executive_orders || []).map do |eo|
      slug = eo['number'].to_s.gsub(/\AEO\s*/i, '').strip
      eo.key?('slug') ? eo : eo.merge('slug' => slug)
    end

    unless eos.any? { |e| e['slug'] == '14404' }
      eos << {
        'slug'         => '14404',
        'number'       => 'EO 14404',
        'date'         => 'May 1, 2026',
        'title'        => "Imposing Sanctions on Cuba's Revolutionary Armed Forces Business Conglomerate GAESA and Blocking Property of Certain Persons Destabilizing Cuba",
        'category'     => 'Foreign Policy',
        'official_url' => 'https://www.federalregister.gov/documents/2026/05/07/2026-10404/imposing-sanctions-on-cubas-revolutionary-armed-forces'
      }
    end

    trump.update!(executive_orders: eos)
  end

  def down
    trump = Person.find_by(slug: 'dtrump-us-president')
    return unless trump
    eos = (trump.executive_orders || []).reject { |e| e['slug'] == '14404' }
    trump.update!(executive_orders: eos)
  end
end
