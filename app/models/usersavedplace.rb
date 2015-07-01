class Usersavedplace < ActiveRecord::Base
  belongs_to :usersavedstory
  belongs_to :place
  validates_uniqueness_of :user_id, :scope => [:usersavedstory_id, :place_id]

end
