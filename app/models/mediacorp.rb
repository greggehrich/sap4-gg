class Mediacorp < ActiveRecord::Base

  validates :title, presence: true

  belongs_to :media_type
  has_many :stories

end