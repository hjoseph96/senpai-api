
# config/initializers/omniauth.rb

require 'rspotify/oauth'

Rails.application.config.middleware.use OmniAuth::Builder do
    client_id = Rails.application.credentials.spotify_id
    spotify_secret = Rails.application.credentials.spotify_token
    provider :spotify, client_id, spotify_secret, scope: 'user-read-email playlist-modify-public user-library-read user-library-modify user-top-read user-library-read'
end

OmniAuth.config.allowed_request_methods = [:post, :get]