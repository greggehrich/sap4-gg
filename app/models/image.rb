class Image < ActiveRecord::Base

  validates :image_type, presence: true

  has_one :url, as: :urlable, dependent: :destroy

  belongs_to :story
  accepts_nested_attributes_for :story

end
