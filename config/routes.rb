Rails.application.routes.draw do
  resources :beers
  resources :breweries
  resources :ratings, only: [:index, :new, :create]

  # Defines the root path route ("/")
  root "breweries#index"

  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html
end