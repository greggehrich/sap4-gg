class Place < ActiveRecord::Base
  
  validates :location_id, presence: true

  has_many :urls, as: :urlable, dependent: :destroy

  has_many :story_place_assignments, dependent: :destroy
  has_many :stories, through: :story_place_assignments
  accepts_nested_attributes_for :stories

  has_many :place_category_assignments, dependent: :destroy
  has_many :place_categories, through: :place_category_assignments

  has_many :usersavedplaces, dependent: :destroy
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

  def get_parent_categories
    place_categories.map{|pc| pc.get_base_category}
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
