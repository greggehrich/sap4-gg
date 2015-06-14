class MapController < ApplicationController

  layout false

  def index
    @favorite_places_json = current_user.favorite_place_coords.to_json
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
