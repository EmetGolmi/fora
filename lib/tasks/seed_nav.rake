namespace :db do
  desc "Re-seed Temple and Forum nav domains/subcategories from canonical seed file"
  task seed_nav: :environment do
    load Rails.root.join("db/seeds/temple_forum_nav.rb").to_s
  end
end
