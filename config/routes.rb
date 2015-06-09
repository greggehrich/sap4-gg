Rails.application.routes.draw do

  resources :locations
  resources :places
  resources :stories

  match 'stories/:id/places' => 'stories#story_places_list', via: [:get]
  match 'stories/:id/places/map' => 'stories#story_places_map', via: [:get], as: 'story_places_map'
  match 'places/:id/map' => 'places#place_map', via: [:get], as: 'place_map'
  match '/my_stories' => 'usersavedstories#my_stories', via: [:get, :post]
  match '/my_storiesandplaces' => 'usersavedstories#my_storiesandplaces', via: [:get, :post]
  match '/usersavedstories/:id' => 'usersavedstories#destroy', via: [:delete], as: :destroy_usersavedstories

  post '/visitors/save_story/:id', to: 'visitors#save_story', as: :save_story
  post '/visitors/forget_story/:id', to: 'visitors#forget_story', as: :forget_story

  match 'visitors/index' => 'visitors#index', via: [:get]

  root to: 'visitors#index'

  devise_for :users
  resources :users

end
