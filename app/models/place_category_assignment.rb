class PlaceCategoryAssignment < ActiveRecord::Base

  validates :place, :place_category, presence: true
  validates :place, uniqueness: {scope: :place_category}

  belongs_to :place
  belongs_to :place_category

end
