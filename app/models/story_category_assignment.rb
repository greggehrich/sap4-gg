class StoryCategoryAssignment < ActiveRecord::Base

  validates :story, :story_category, presence: true
  validates :story, uniqueness: {scope: :story_category}

  belongs_to :story
  belongs_to :story_category

end
