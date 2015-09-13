class Image < ActiveRecord::Base
  # before_validation :check_manual_url, on: :create

  # validates :image_type, :presence => { :message => "IMAGE TYPE is required" }
  validates :image_size_h, :presence => { :message => "HORIZONTAL PX SIZE is required" }
  validates :image_size_v, :presence => { :message => "VERICAL PX SIZE is required" }
  validates :source, :presence => { :message => "SOURCE is required" }

  has_one :url, as: :urlable, dependent: :destroy
  accepts_nested_attributes_for :url

  belongs_to :story

  attr_accessor :image_data

  # def check_manual_url
  #   self.source ||= self.manual_url
  #   self.manual_enter = (self.manual_url.present? ? true : false)
  # end

end
