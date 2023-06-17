Rails.application.routes.draw do
  if Rails.env.development?
    mount GraphiQL::Rails::Engine, at: "/graphiql", graphql_path: "/graphql"
  end
  
  post "/graphql", to: "graphql#execute"
  
  mount ActionCable.server => '/cable'

  get '/auth/spotify/callback', to: 'spotify#callback'
  get '/auth/spotify/', to: 'spotify#test'

  root 'hello#hi_senpai'
  
  devise_for :users, skip: :sessions
end
