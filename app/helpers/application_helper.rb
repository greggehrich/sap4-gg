module ApplicationHelper

  # added these three methods for devise access by login modal
  def resource_name
    :user
  end

  def resource
    @resource ||= User.new
  end

  def story_saved?(st_id,us_id)
    if user_signed_in?
      Usersavedstory.where("story_id = #{st_id} and user_id = #{us_id}").count == 1 ? true : false
    end
  end

  def devise_mapping
    @devise_mapping ||= Devise.mappings[:user]
  end

end
