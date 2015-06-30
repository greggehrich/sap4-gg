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
        render json: Location.nearby_places(parse_location_params,50)
      end
    end
  end

  private

  def parse_location_params
    if params[:location_coords_text].present?
      params[:location_coords_text].split(',')
    end
  end

end
