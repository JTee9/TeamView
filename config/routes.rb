Rails.application.routes.draw do

  devise_for :users
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html
  root "teams#index"
  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  resources :teams do
    collection do
      post :update_standings
    end
    member do
      post :update_squad
    end
  end

  # Custom routes for favorites using API football ID
  post '/teams/:api_football_id/favorite', to: 'teams#favorite', as: 'favorite_team'
  delete '/teams/:api_football_id/unfavorite', to: 'teams#unfavorite', as: 'unfavorite_team'

  # Defines the root path route ("/")
  # root "posts#index"
end
