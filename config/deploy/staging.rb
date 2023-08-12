set :stage, :staging
set :rails_env, :staging
set :branch, 'insomnia'
server '3.15.192.97', user: 'ubuntu', roles: %w{web app db}