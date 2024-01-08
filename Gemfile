source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '3.2.2'

# Bundle edge Rails instead: gem "rails", github: "rails/rails", branch: "main"
gem 'rails', '~> 7.1'

# The original asset pipeline for Rails [https://github.com/rails/sprockets-rails]
gem 'sprockets-rails'

# Use postgresql as the database for Active Record
gem 'pg', '~> 1.1'

# Use the Puma web server [https://github.com/puma/puma]
gem 'puma', '~> 5.6'

# Use JavaScript with ESM import maps [https://github.com/rails/importmap-rails]
gem 'importmap-rails'

# Hotwire's modest JavaScript framework [https://stimulus.hotwired.dev]
gem 'stimulus-rails'

# Use Redis adapter to run Action Cable in production
gem 'redis', '~> 4.0'
gem 'hiredis'

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: %i[ mingw mswin x64_mingw jruby ]

# Reduces boot times through caching; required in config/boot.rb
gem 'bootsnap', require: false

gem 'rack-cors'

gem 'devise'
gem 'graphql'
gem 'batch-loader'
gem 'activerecord-postgis-adapter'
gem 'active_storage_validations'
gem 'jwt'
gem 'bcrypt'
gem 'twilio-ruby'
gem 'geocoder'
gem 'aws-sdk-locationservice'
gem 'rspotify'
gem 'sidekiq'
gem 'pg_search', '~> 2.3', '>= 2.3.6' 
gem 'kaminari'
gem 'appsignal'
gem "apollo_upload_server", ">= 2.1.0"
gem "graphql-client", github: "rmosolgo/graphql-client", ref: "27ef61f"
gem 'graphlient'
gem 'ruby-vips'
gem 'acts_as_paranoid'
gem 'faker'
gem 'faraday'
gem 'sidekiq-cron'
gem 'aws-sdk-s3'
gem 'nokogiri'
gem 'bulma-rails', '~> 0.9.4'
gem 'active_model_serializers', '~> 0.10.0'


group :development, :test do
  # See https://guides.rubyonrails.org/debugging_rails_applications.html#debugging-with-the-debug-gem
  gem 'debug', platforms: %i[ mri mingw x64_mingw ]
  gem 'pry-rails'
  gem 'graphiql-rails'
end

group :development do
  # Use console on exceptions pages [https://github.com/rails/web-console]
  gem 'bullet'
  gem 'web-console'
  # Add speed badges [https://github.com/MiniProfiler/rack-mini-profiler]
  gem "rack-mini-profiler"

  # Speed up commands on slow machines / big apps [https://github.com/rails/spring]
  gem "spring"
end