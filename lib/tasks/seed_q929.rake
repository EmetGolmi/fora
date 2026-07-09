namespace :q929 do
  desc "Seed Q929 Sacred Fire & Destruction Registry"
  task seed: :environment do
    $stdout.sync = true
    puts "Q929 rake: starting seed"
    begin
      load Rails.root.join('db/seeds/q929_sacred_fires.rb')
      puts "Q929 rake: seed completed"
    rescue => e
      puts "Q929 rake ERROR: #{e.class}: #{e.message}"
      puts e.backtrace.first(5).join("\n")
      raise
    end
  end
end
