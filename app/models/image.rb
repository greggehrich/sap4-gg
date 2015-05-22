class Image < ActiveRecord::Base

  validates :image_type, presence: true

  belongs_to :urls, as: :urlable, dependent: :destroy

  belongs_to :story
end
