class Story < ActiveRecord::Base

  # TODO: no validations!

  has_many :urls, as: :urlable, dependent: :destroy

  has_many :story_place_assignments
  has_many :places, through: :story_place_assignments

  has_many :story_category_assignments
  has_many :story_categories, through: :story_category_assignments

  has_many :author_story_assignments
  has_many :authors, through: :author_story_assignments

  has_many :images
  belongs_to :mediacorp

  scope :ready_for_display, -> {where(ready_for_display: true)}

end
