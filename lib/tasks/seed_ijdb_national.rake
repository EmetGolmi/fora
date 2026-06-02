namespace :ijdb do
  desc "Seed national IJDB entries"
  task seed_national: :environment do
    load Rails.root.join('db/seeds/ijdb_national.rb')
    puts "Done. National entries: #{IjdbEntry.where(city: nil, country: 'usa').count}"
  end
end
