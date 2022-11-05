Rails.application.routes.draw do
  resources :memberships, only: [:new, :create]
  resources :beer_clubs
  resources :users
  resources :beers
  resources :breweries
  resources :ratings, only: [:index, :new, :create, :destroy]
  resource :session, only: [:new, :create, :destroy]

  # Defines the root path route ("/")
  root "breweries#index"

  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html
  get "signup", to: "users#new"
  get "signin", to: "sessions#new"
  delete "signout", to: "sessions#destroy"
end