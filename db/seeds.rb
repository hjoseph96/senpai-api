require_relative './seeds/anilist_seeder'
require_relative './seeds/profile_seeder'
require_relative './seeds/sticker_seeder'

# AnilistSeeder.create_animes

ProfileSeeder.create_profiles(location: 'NYC')
ProfileSeeder.create_profiles(location: 'KIEV')
ProfileSeeder.create_profiles(location: 'KAMPALA')

StickerSeeder.create_stickers