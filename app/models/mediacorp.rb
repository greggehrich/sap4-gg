class Mediacorp < ActiveRecord::Base

  validates :title, presence: true

  has_one :url, as: :urlable, dependent: :destroy
  belongs_to :media_type
  has_many :stories

end