class StoriesController < ApplicationController
  before_action :set_story, only: [:show, :edit, :update, :destroy]

  def index
    page = params[:page] ? params[:page] : 1
    @stories = Story.ready_for_display.paginate(per_page: 50, page: page).order('created_at DESC')
    @stories = @stories.where(["title ILIKE ?", "%#{params[:search]}%"]) if params[:search]

  end

  # this show will eventually go away
  def show
    @story = Story.where(ready_for_display: true).find(params[:id])
    @places = @story.places

    if user_signed_in?
      @saved_story_count = Usersavedstory.where(story_id: @story.id, user_id: current_user.id.to_i).count
      # binding.pry
    end

  end

  def edit
    @story = Story.find(params[:id])
    # redirect_to :storyplace/edit
  end

  def update
    @story.update(story_params)
    redirect_to story_path
  end

  def save_story_show
    if user_signed_in?
      user_saved_story = Usersavedstory.new
      user_saved_story.user_id = current_user.id.to_i
      user_saved_story.story_id = params[:id].to_i

      user_saved_story_success = true if user_saved_story.save

      @story = Story.find(params[:id])
      @places_for_this_story = @story.places
      @places_for_this_story.each do |story_places|
        user_saved_place = Usersavedplace.new
        user_saved_place.user_id = current_user.id.to_i
        user_saved_place.usersavedstory_id = Usersavedstory.last.id
        user_saved_place.place_id = story_places.id
        user_saved_place.save
        # binding.pry
      end

      # if user_saved_story_success
      #   render json: {success: true}
      # else
      #   render json: {success: false}
      # end

    redirect_to :back
    # redirect_to '/stories/' + params[:id].to_s
    end
  end

  def forget_story_show
    if user_signed_in?

      user_saved_story = Usersavedstory.where(story_id: params[:id], user_id: current_user.id).first
      user_saved_story.destroy

      redirect_to :back
      # redirect_to '/stories/' + params[:id].to_s
    end
  end

  def story_places_list
    @story = Story.where(ready_for_display: true).find(params[:id])

  end

  def story_places_map
    @story = Story.where(ready_for_display: true).find(params[:id])
    @places = @story.places

    # the hash holds all the markers for the map
    @hash = Gmaps4rails.build_markers(@places) do |place, marker|
      marker.lat place.location.lat
      marker.lng place.location.lng
      name = place.name.present? ? place.name : ''
      marker.infowindow '<a class="iwlayout" href=' + place_path(place) + '>' + name + '</a>'
    end

  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_story
      @story = Story.find(params[:id])
    end
    # Never trust parameters from the scary internet, only allow the white list through.
    def story_params
      params.require(:story).permit(:title, places_attributes: [ :id, :name, :_destroy ])
    end

end
