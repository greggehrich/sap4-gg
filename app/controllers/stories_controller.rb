class StoriesController < ApplicationController


  def index
    page = params[:page] ? params[:page] : 1
    @stories = Story.ready_for_display.paginate(per_page: 50, page: page).order('created_at DESC')
    @stories = @stories.where(["title ILIKE ?", "%#{params[:search]}%"]) if params[:search]

  end

  def show
    @story = Story.find(params[:id])
    @places = @story.places

    # the hash holds all the markers for the map
    @hash = Gmaps4rails.build_markers(@places) do |place, marker|
      marker.lat place.location.lat
      marker.lng place.location.lng
      marker.infowindow place.name
    end

  end

end
