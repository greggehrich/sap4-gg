class MapController < ApplicationController

  def index
    @favorite_places_json = current_user.favorite_place_coords.to_json
  end

  def index_test

  end

  def show

  end

  def all_nearby_places
    respond_to do |format|
      format.json do
        render json: Location.nearby_places(params[:location_text],50)
      end
    end
  end

end
