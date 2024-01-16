namespace :senpai do
  task seed_profiles: :environment do
    require "#{Rails.root}/db/seeds/profile_seeder"

    ProfileSeeder.create_profiles(location: 'NYC')
    ProfileSeeder.create_profiles(location: 'ATLANTIC CITY')
    ProfileSeeder.create_profiles(location: 'KIEV')
    ProfileSeeder.create_profiles(location: 'KAMPALA')
    ProfileSeeder.create_profiles(location: 'MANDI')
    ProfileSeeder.create_profiles(location: 'CHANDIGARH')
    ProfileSeeder.create_profiles(location: 'PALO ALTO')
  end
end