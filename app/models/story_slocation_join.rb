class StorySlocationJoin < ActiveRecord::Base
  validates :story_id, :slocation_id, presence: true

  belongs_to :story
  belongs_to :slocation
end
