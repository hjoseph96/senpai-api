namespace :senpai do
  task seed_stickers: :environment do
    require "#{Rails.root}/db/seeds/sticker_seeder"

    StickerSeeder.create_stickers
  end
end