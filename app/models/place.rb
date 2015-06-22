class Place < ActiveRecord::Base

  validates :location_id, presence: true

  has_many :urls, as: :urlable, dependent: :destroy

  has_many :story_place_assignments
  has_many :stories, through: :story_place_assignments

  has_many :place_category_assignments
  has_many :place_categories, through: :place_category_assignments

  has_many :usersavedplaces
  belongs_to :location
  belongs_to :parent, class_name: 'Place', foreign_key: :parent_id

  def is_parent?
    location_id == 0
  end

  def full_name
    parent_id ? parent_full_name : name
  end

  def is_child?
    parent_id.present?
  end

  private

  def parent_full_name
    if parent.name.present? && name.present?
      parent.name + ': ' + name + ' [has parent - this name is parent name + my name]' # obviously temporary
    elsif parent.name.present?
      parent.name + " [using parent's name - i have no name]" # obviously temporary
    else
      name
    end
  end


end
