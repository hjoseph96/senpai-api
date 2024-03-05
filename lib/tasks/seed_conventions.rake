namespace :senpai do
  task seed_conventions: :environment do
    require "#{Rails.root}/db/seeds/convention_seeder"

    ConventionSeeder.create_conventions
  end
end