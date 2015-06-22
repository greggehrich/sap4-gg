class PlacesController < ApplicationController

  def index
    page = params[:page] ? params[:page] : 1
    @places = Place.paginate(per_page: 50, page: page)
    @places = @places.where(["name ILIKE ?", "%#{params[:search]}%"]) if params[:search].present?
  end

  def show
    @place = Place.find(params[:id])
    @location = @place.location

  end

  def place_map
    @place = Place.find(params[:id])

    # the hash holds all the markers for the map
    @place_hash = Gmaps4rails.build_markers(@place) do |place, marker|
      marker.lat place.location.lat
      marker.lng place.location.lng
      name = place.name.present? ? place.name : ''
      marker.infowindow '<a class="iwlayout" href=' + place_path(place) + '>' + name + '</a>'
    end

  end

end
