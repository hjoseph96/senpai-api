class SyncAnimeJob
    include Sidekiq::Job

    def perform
        AnilistSeeder.create_animes
    end
end