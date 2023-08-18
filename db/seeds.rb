require_relative './seeds/profile_seeder'
require_relative './seeds/anilist_seeder'

AnilistSeeder.create_animes
ProfileSeeder.create_profiles