class PlaceCategory < ActiveRecord::Base

  validates :name, presence: true

  has_many :place_category_assignments
  has_many :places, through: :place_category_assignments

  belongs_to :parent, class_name: 'PlaceCategory', foreign_key: :parent_id

  def get_base_category
    return self if parent.nil?
    parent.get_base_category
  end

  def parent_category
    PlaceCategory.find_by(id: parent_id)
  end

end
