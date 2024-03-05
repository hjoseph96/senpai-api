namespace :senpai do
  task seed_events: :environment do
    require "#{Rails.root}/db/seeds/event_seeder"

    EventSeeder.create_events
  end
end