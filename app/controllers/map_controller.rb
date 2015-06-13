class MapController < ApplicationController

  layout false

  def index
  end

  def favorite_place_locations
    respond_to do |format|
      format.json do
        render json: current_user.favorite_place_coords
      end
    end
  end

end
