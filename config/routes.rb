Rails.application.routes.draw do
  devise_for :users
  root to: "pages#home"
  # get "contact", to: "pages#contact"
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  resources :itineraries, except: %i[index edit new] do
    resources :collaborations, except: %i[new edit update destroy]
    resources :messages, only: [:create]
    resources :selections, only: %i[index]
    resources :activities
  end

  resources :collaborations, only: [:destroy]
  resources :activities, only: [:index, :show, :new, :create] do
    resources :selections, only: %i[new create] do
      resources :reviews, only: %i[new create]
    end
  end

  resources :selections, only: %i[destroy edit update]

  resources :notifications, only: [:index] do
    member do
      patch :toggle_read
    end
  end
end
