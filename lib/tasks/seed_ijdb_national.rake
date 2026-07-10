namespace :ijdb do
  desc "Seed national IJDB entries"
  task seed_national: :environment do
    load Rails.root.join('db/seeds/ijdb_national.rb')
    puts "Done. National entries: #{IjdbEntry.where(city: nil, country: 'usa').count}"
    # Q929 sacred fire registry seeded in same task to avoid second Rails boot
    $stdout.sync = true
    puts "Q929: starting seed"
    begin
      load Rails.root.join('db/seeds/q929_sacred_fires.rb')
      puts "Q929: seed done (#{SacredFireEntry.count} entries)"
    rescue => e
      puts "Q929 ERROR: #{e.class}: #{e.message}"
      puts e.backtrace.first(3).join("\n")
    end
    # Temple/Forum nav domains
    begin
      load Rails.root.join('db/seeds/temple_forum_nav.rb')
    rescue => e
      puts "Temple/Forum nav ERROR: #{e.class}: #{e.message}"
      puts e.backtrace.first(3).join("\n")
    end
  end
end
