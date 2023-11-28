Rails.application.routes.draw do
  if Rails.env.development?
    mount GraphiQL::Rails::Engine, at: "/graphiql", graphql_path: "/graphql"
  end
  
  post "/graphql", to: "graphql#execute"
  
  mount ActionCable.server => '/cable'

  get '/auth/spotify/callback', to: 'spotify#callback'
  get '/auth/spotify/', to: 'spotify#test'

  root 'hello#hi_senpai'

  namespace :v1 do
    namespace :admin do

      resources :users do
        collection do
          get '/all_users', to: 'users#all_users'
        end

        post '/ban_user', to: 'users#ban_user', as: :ban_user
        post '/warn_user', to: 'users#warn_user', as: :warn_user
      end

      post 'verify_request', to: 'verify_requests#index'
      post 'verify_request/:id', to: 'verify_requests#show'
      post 'verify_request/:id/approve', to: 'verify_requests#approve'
      post 'verify_request/:id/deny', to: 'verify_requests#deny'

      get 'reports', to: 'reports#index'
      get 'reports/:id', to: 'reports#show'
      post 'reports/:id/resolve', to: 'reports#resolve', as: 'resolve_report'
    end
  end
  
  devise_for :users, skip: :sessions
end
