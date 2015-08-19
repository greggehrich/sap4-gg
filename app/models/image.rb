class Image < ActiveRecord::Base

  validates :image_type, presence: true
  validates :image_type, :presence => { :message => "IMAGE TYPE is required" }
  validates :image_size_h, :presence => { :message => "HORIZONTAL PX SIZE is required" }
  validates :image_size_v, :presence => { :message => "VERICAL PX SIZE is required" }
  validates :source, :presence => { :message => "SOURCE is required" }

  has_one :url, as: :urlable, dependent: :destroy
  accepts_nested_attributes_for :url

  belongs_to :story
  # accepts_nested_attributes_for :story

end
