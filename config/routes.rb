# frozen_string_literal: true

Rails.application.routes.draw do
  devise_for :users
  resources :users, only: %i[index edit update destroy show] do
    member do
      put 'set_bnr'
      put 'clear_bnr'
      put 'set_admin'
      put 'clear_admin'
    end
  end
  resources :activities, only: %i[index show] do
    collection do
      post 'sync_data'
    end
  end
  resources :challenges do
    member do
      post 'join'
      post 'quit'
      post 'sync_data'
      post 'remove_user'
    end
  end
  resources :groups do
    member do
      post 'join'
      post 'quit'
      post 'remove_user'
    end
  end
  root to: 'pages#home'
  get 'connect_strava', to: 'pages#connect_strava'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
