class UsersavedstoriesController < ApplicationController

  def my_stories
    @my_stories = Usersavedstory.where(user_id: current_user.id).order("id DESC") if user_signed_in?
  end

  def my_storiesandplaces

    if user_signed_in?
      page = params[:page] ? params[:page] : 1
      @my_stories = Usersavedstory.joins(:story).where(stories: { ready_for_display: true }, user_id: current_user.id).paginate(per_page: 50, page: page)
      @my_stories = @my_stories.order("usersavedstories.id DESC")
      @my_stories = @my_stories.where(["title ILIKE ?", "%#{params[:search]}%"]) if params[:search]
    end

    # @my_stories = Usersavedstory.where(user_id: current_user.id).order("id DESC") if user_signed_in?
  end

  def destroy
    if user_signed_in?
      user_saved_story = Usersavedstory.where(story_id: params[:id], user_id: current_user.id).first
      user_saved_story.destroy
      redirect_to '/my_storiesandplaces'
    end
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  # def user_saved_story_params
  #   params.require(:usersavedstory).permit(:id, :user_id, :story_id)
  # end

end