namespace :senpai do
  task seed_tournaments: :environment do
    require "#{Rails.root}/db/seeds/tournament_seeder"

    TournamentSeeder.create_tournaments
  end
end