Rails.application.routes.draw do
  resources :memberships, only: [:new, :create, :destroy]
  resources :beer_clubs
  resources :users do
    post "toggle_account_status", on: :member
  end
  resources :beers
  resources :breweries do
    post "toggle_activity", on: :member
  end
  resources :ratings, only: [:index, :new, :create, :destroy]
  resource :session, only: [:new, :create, :destroy]
  resources :places, only: [:index, :show]
  resources :styles, only: [:index, :show, :edit, :destroy]

  # Defines the root path route ("/")
  root "breweries#index"

  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html
  get "signup", to: "users#new"
  get "signin", to: "sessions#new"
  delete "signout", to: "sessions#destroy"
  post "places", to: "places#search"
  get "beerlist", to: "beers#list"
  get "brewerylist", to: "breweries#list"
end
