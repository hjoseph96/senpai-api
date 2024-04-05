namespace :senpai do
  task seed_anime: :environment do
    require "#{Rails.root}/db/seeds/anilist_seeder"

    AnilistSeeder.create_animes
  end
end