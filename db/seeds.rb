require_relative './seeds/anilist_seeder'
require_relative './seeds/profile_seeder'
require_relative './seeds/sticker_seeder'

# AnilistSeeder.create_animes
3077.times {|i| puts i; ProfileSeeder.create_profiles }
# StickerSeeder.create_stickers