class Story < ActiveRecord::Base

  # TODO: no validations!

  belongs_to :image
  belongs_to :media

  has_many :urls, as: :urlable, dependent: :destroy

  has_many :story_place_assignments
  has_many :stories, through: :story_place_assignments

  has_many :story_category_assignments
  has_many :story_categories, through: :story_category_assignments

  has_many :author_story_assignments
  has_many :authors, through: :author_story_assignments

  belongs_to :image # NOTE: this seems limiting
  belongs_to :media

end
