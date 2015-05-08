class Place < ActiveRecord::Base

  validates :location, presence: true # TODO: ask if this is correct ?

  has_many :urls, as: :urlable, dependent: :destroy

  has_many :story_place_assignments
  has_many :stories, through: :story_place_assignments

  has_many :place_category_assignments
  has_many :place_categories, through: :place_category_assignments

  belongs_to :location

  def is_parent?
    location_id == 0
  end

  def is_child?
    parent_id.present?
  end
  
end
