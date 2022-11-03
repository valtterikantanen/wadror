Rails.application.routes.draw do
  resources :beers
  resources :breweries

  # Defines the root path route ("/")
  root "breweries#index"

  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html
  get "ratings", to: "ratings#index"
  post "ratings", to: "ratings#create"
  get "ratings/new", to: "ratings#new"
end