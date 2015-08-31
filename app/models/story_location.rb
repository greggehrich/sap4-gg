class StoryLocation < ActiveRecord::Base
  validates :story_id, :slocation_id, presence: true
  validates :story_id, uniqueness: {scope: :slocation_id}

  belongs_to :story
  belongs_to :slocation
end
