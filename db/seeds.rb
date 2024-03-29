require_relative './seeds/anilist_seeder'
require_relative './seeds/profile_seeder'
require_relative './seeds/sticker_seeder'
require_relative './seeds/convention_seeder'
require_relative './seeds/event_seeder'
require "#{Rails.root}/db/seeds/tournament_seeder"

AnilistSeeder.create_animes

ProfileSeeder.create_profiles(location: 'NYC')
ProfileSeeder.create_profiles(location: 'ATLANTIC CITY')
ProfileSeeder.create_profiles(location: 'KIEV')
ProfileSeeder.create_profiles(location: 'KAMPALA')
ProfileSeeder.create_profiles(location: 'MANDI')
ProfileSeeder.create_profiles(location: 'CHANDIGARH')
ProfileSeeder.create_profiles(location: 'PALO ALTO')
ProfileSeeder.create_profiles(location: 'TOKYO')
ProfileSeeder.create_profiles(location: 'JUIZ DE FORA')

StickerSeeder.create_stickers

ConventionSeeder.create_conventions

EventSeeder.create_events

TournamentSeeder.create_tournaments