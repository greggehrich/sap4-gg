class Story < ActiveRecord::Base

  validates :editor_tagline, :presence => { :message => "EDITOR TAGLINE is required" }
  validates :description, :presence => { :message => "DESCRIPTION is required" }
  validates :title, :presence => { :message => "TITLE is required" }

  attr_accessor :slocation_ids, :splace_category_ids, :story_category_ids

  # TODO: no validations!

  # these next 4 relationships are temporary bridges until places are fully implemented
  has_many :story_slocation_joins, dependent: :destroy
  has_many :slocations, through: :story_slocation_joins
  accepts_nested_attributes_for :slocations
  has_many :story_splace_joins, dependent: :destroy
  has_many :splace_categories, through: :story_splace_joins
  accepts_nested_attributes_for :splace_categories

  has_many :urls, as: :urlable, dependent: :destroy
  accepts_nested_attributes_for :urls

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
