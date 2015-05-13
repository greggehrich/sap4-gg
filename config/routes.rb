Rails.application.routes.draw do

  devise_for :users
  resources :users

  resources :stories
  resources :places
  resources :locations

  root to: 'stories#index'
end
