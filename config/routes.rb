Rails.application.routes.draw do
  devise_for :users
  root to: "pages#home"
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"

  resources :itineraries, only: [:index, :new, :show, :create, :destroy]
  resources :collaborations, only: [:index, :new, :show]

  resources :activities, only: [:index, :show]
end
