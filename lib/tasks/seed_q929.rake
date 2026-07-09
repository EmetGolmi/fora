namespace :q929 do
  desc "Seed Q929 Sacred Fire & Destruction Registry"
  task seed: :environment do
    load Rails.root.join('db/seeds/q929_sacred_fires.rb')
  end
end
