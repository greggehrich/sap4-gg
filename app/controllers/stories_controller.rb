class StoriesController < ApplicationController


  def index
    page = params[:page] ? params[:page] : 1
    @stories = Story.ready_for_display.paginate(per_page: 50, page: page).order('created_at DESC')
    @stories = @stories.where(["title ILIKE ?", "%#{params[:search]}%"]) if params[:search]
  end

  def show
    @story = Story.find(params[:id])
  end

end
