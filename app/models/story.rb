class Story < ActiveRecord::Base

  # TODO: no validations!

  has_many :urls, as: :urlable, dependent: :destroy
  has_many :usersavedstories, dependent: :destroy

  has_many :story_place_assignments, dependent: :destroy
  has_many :places, through: :story_place_assignments
  accepts_nested_attributes_for :places,  allow_destroy: true

  has_many :story_category_assignments, dependent: :destroy
  has_many :story_categories, through: :story_category_assignments
  accepts_nested_attributes_for :story_categories

  has_many :author_story_assignments, dependent: :destroy
  has_many :authors, through: :author_story_assignments
  accepts_nested_attributes_for :authors

  has_many :images
  accepts_nested_attributes_for :images, allow_destroy: true
  
  belongs_to :mediacorp
  accepts_nested_attributes_for :mediacorp

  scope :ready_for_display, -> {where(ready_for_display: true)}

end
