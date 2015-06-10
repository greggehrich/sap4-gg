class UsersavedplacesController < ApplicationController

  def index
    if user_signed_in?
      page = params[:page] ? params[:page] : 1
      @my_savedplaces = Usersavedplace.joins(:place).where(user_id: current_user.id).paginate(per_page: 50, page: page)
      # @my_savedplaces = Usersavedplace.where(user_id: current_user.id).order("id DESC").place.paginate(per_page: 50, page: page)
      # @places = Place.paginate(per_page: 50, page: page)
      @my_savedplaces = @my_savedplaces.where(["name ILIKE ?", "%#{params[:search]}%"]) if params[:search].present?
    end
  end

end