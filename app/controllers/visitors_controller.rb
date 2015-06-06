class VisitorsController < ApplicationController
  # before_filter :authenticate_user!
  # after_action :verify_authorized

  def index
    @stories = Story.where(ready_for_display: true).order("id DESC").first(21)
    # @stories = Story.order("id DESC").all.includes(:urls)
  end

  def save_story
    respond_to do |format|
      format.json do
        if user_signed_in?
          user_saved_story = Usersavedstory.new
          user_saved_story.user_id = current_user.id.to_i
          user_saved_story.story_id = params[:id].to_i
          if user_saved_story.save
            render json: {success: true}
          else
            render json: {success: false}
          end
        end
      end
    end
  end

  def forget_story
    respond_to do |format|
      format.json do
        if user_signed_in?
          user_saved_story = Usersavedstory.where(story_id: params[:id], user_id: current_user.id).first
          if user_saved_story && user_saved_story.destroy
            render json: {success: true}
          else
            render json: {success: false}
          end
        end
      end
    end
  end

end
