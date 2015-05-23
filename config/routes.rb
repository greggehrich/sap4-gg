Rails.application.routes.draw do

  devise_for :users
  resources :users

  resources :stories
  match 'visitors/index' => 'visitors#index', via: [:get]

  resources :places
  resources :locations

  root to: 'stories#index'
end
