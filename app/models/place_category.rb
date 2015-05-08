class PlaceCategory < ActiveRecord::Base

  validates :name, presence: true

  has_many :place_category_assignments
  has_many :places, through: :place_category_assignments

end
