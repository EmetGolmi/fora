namespace :db do
  namespace :seed do
    desc "Seed OnThisDayEntry records from db/seeds/on_this_day_philadelphia.rb"
    task on_this_day: :environment do
      load Rails.root.join("db/seeds/on_this_day_philadelphia.rb").to_s

      seed_keys = ON_THIS_DAY_ENTRIES.map { |e| [e[:month], e[:day], e[:year], e[:entry_type].to_s, e[:title]] }
      OnThisDayEntry.find_each do |r|
        OnThisDayEntry.delete(r.id) unless seed_keys.include?([r.month, r.day, r.year, r.entry_type, r.title])
      end

      created = updated = 0
      ON_THIS_DAY_ENTRIES.each do |entry|
        record = OnThisDayEntry.find_or_initialize_by(
          month:      entry[:month],
          day:        entry[:day],
          year:       entry[:year],
          entry_type: entry[:entry_type].to_s,
          title:      entry[:title]
        )
        is_new = record.new_record?

        record.assign_attributes(
          body:              entry[:body],
          quote:             entry[:quote],
          quote_attribution: entry[:quote_attribution],
          neighborhood:      entry[:neighborhood],
          is_featured:       entry[:is_featured] || false,
          sources:           entry[:sources] || [],
          verified:          entry[:verified].to_s
        )
        record.save!
        is_new ? created += 1 : updated += 1
      end

      puts "OnThisDayEntry: #{created} created, #{updated} updated"
    end
  end
end
