require "#{Rails.root}/db/seeds/anilist_seeder"

class SyncAnimeJob
    include Sidekiq::Job

    def perform
        AnilistSeeder.create_animes
    end
end