# Load the Rails application.
require_relative "application"

Rails.application.configure do
  config.action_cable.allowed_request_origins = [/http:\/\/*/, /https:\/\/*/, /file:\/\/*/, 'file://', nil]
end


# Initialize the Rails application.
Rails.application.initialize!
