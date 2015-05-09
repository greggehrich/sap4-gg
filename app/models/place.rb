class Place < ActiveRecord::Base

  # note validate by location_id because parent places will have location_id == 0
  validates :location_id, presence: true

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
