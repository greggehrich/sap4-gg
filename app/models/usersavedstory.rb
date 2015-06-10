class Usersavedstory < ActiveRecord::Base
  belongs_to :user
  belongs_to :story
  has_many :usersavedplaces, dependent: :destroy
  validates_uniqueness_of :user_id, :scope => :story_id

end