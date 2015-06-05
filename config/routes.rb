Rails.application.routes.draw do

  resources :locations
  resources :places
  resources :stories

  match 'stories/:id/places' => 'stories#story_places_list', via: [:get]
  match 'stories/:id/places/map' => 'stories#story_places_map', via: [:get], as: 'story_places_map'
  match 'places/:id/map' => 'places#place_map', via: [:get], as: 'place_map'

  match 'visitors/index' => 'visitors#index', via: [:get]

  root to: 'visitors#index'

  devise_for :users
  resources :users

end
