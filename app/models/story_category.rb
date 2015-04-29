class StoryCategory < ActiveRecord::Base

  validates :name, :code, presence: true
  validates :code, uniqueness: true

  has_many :story_category_assignments
  has_many :stories, through: :story_category_assignments

end
