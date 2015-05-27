Rails.application.routes.draw do

  devise_for :users
  resources :users
  resources :locations

  resources :places

  match 'stories/:id/places' => 'stories#story_places_list', via: [:get]
  match 'stories/:id/places/map' => 'stories#story_places_map', via: [:get]

  resources :stories

  match 'visitors/index' => 'visitors#index', via: [:get]

  root to: 'stories#index'
end
