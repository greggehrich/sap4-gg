class Image < ActiveRecord::Base

  validates :image_type, presence: true

  has_one :story
end
