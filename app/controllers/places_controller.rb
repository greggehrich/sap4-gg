class PlacesController < ApplicationController

  def index
    page = params[:page] ? params[:page] : 1
    @places = Place.paginate(per_page: 20, page: page)
    @places = @places.where(["name ILIKE ?", "%#{params[:search]}%"]) if params[:search].present?
  end

  def show
    @place = Place.find(params[:id])
    @location = @place.location
  end

end
