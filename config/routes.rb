Rails.application.routes.draw do

  match 'stories/new' => 'stories#new', via: [:get, :post]
  match 'stories/start' => 'stories#start', via: [:get, :post]

  match 'stories/:id/places' => 'stories#story_places_list', via: [:get]
  match 'stories/:id/places/map' => 'stories#story_places_map', via: [:get], as: 'story_places_map'
  match 'places/:id/map' => 'places#place_map', via: [:get], as: 'place_map'
  match '/my_stories' => 'usersavedstories#my_stories', via: [:get, :post]
  match '/my_storiesandplaces' => 'usersavedstories#my_storiesandplaces', via: [:get, :post]
  match '/usersavedstories/:id' => 'usersavedstories#destroy', via: [:delete], as: :destroy_usersavedstories
  match '/my_savedplaces' => 'usersavedplaces#index', via: [:get, :post]
  match '/story/save_story_show/:id' => 'stories#save_story_show', via: [:get, :post], as: :save_story_show
  match '/story/forget_story_show/:id' => 'stories#forget_story_show', via: [:get, :post], as: :forget_story_show

  post '/visitors/save_story/:id', to: 'visitors#save_story', as: :save_story
  post '/visitors/forget_story/:id', to: 'visitors#forget_story', as: :forget_story

  match 'visitors/index' => 'visitors#index', via: [:get]

  root to: 'visitors#index'

  devise_for :users
  resources :users
  resources :hoteljunks
  resources :locations
  resources :slocations
  resources :splace_categories
  resources :story_categories
  resources :places
  resources :stories
  resources :map, only: [:index] do
    collection do
      get 'all_nearby_places'
    end
  end

end
