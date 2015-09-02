class StoryPlaceCategory < ActiveRecord::Base
  validates :story_id, :splace_category_id, presence: true
  validates :story_id, uniqueness: {scope: :splace_category_id}

  belongs_to :story
  belongs_to :splace_category
end
