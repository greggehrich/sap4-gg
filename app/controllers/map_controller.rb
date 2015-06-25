class MapController < ApplicationController

  # layout false

  def index
    @favorite_places_json = current_user.favorite_place_coords.to_json
  end

  def index_test

  end

  def show

  end

  def my_places
    @usersavedplaces = Usersavedplace.where(user_id: current_user.id)

    # the hash holds all the markers for the map
    @my_places_hash = Gmaps4rails.build_markers(@usersavedplaces) do |pl, marker|
      marker.lat pl.place.location.lat
      marker.lng pl.place.location.lng
      name = pl.place.name.present? ? pl.place.name : ''
      marker.infowindow '<a class="iwlayout" href=' + place_path(pl.place_id) + '>' + name + '</a>'
      # binding.pry
    end

  end

  def all_places
    @all_nearby_places = Location.near('San Diego').joins(:places)

    # the hash holds all the markers for the map
    @all_places_hash = Gmaps4rails.build_markers(@all_nearby_places) do |pl, marker|
      marker.lat pl.lat
      marker.lng pl.lng
      name = pl.places.name.present? ? pl.places.name : ''
      marker.infowindow '<a class="iwlayout" href=' + place_path(pl.places.first.id) + '>' + name + '</a>'
    end
  # binding.pry
  end

  # Using AJAX call in case you do not want to eager load
  # def favorite_place_locations
  #   respond_to do |format|
  #     format.json do
  #       render json: current_user.favorite_place_coords
  #     end
  #   end
  # end

end
