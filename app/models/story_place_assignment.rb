class StoryPlaceAssignment < ActiveRecord::Base

  validates :story, :place, presence: true
  validates :story, uniqueness: {scope: :place}

  belongs_to :story
  belongs_to :place

end
